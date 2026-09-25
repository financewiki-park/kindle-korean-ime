/*
 * Kindle X11 bridge prototype. It deliberately has no service installer: a
 * device-specific Probe report must approve window/keycode behavior first.
 * The event strategy is informed by Kingul (MIT, hy1o/kingul), but this file
 * is an independent implementation using this project's composition core.
 */
#include "hangul_core.h"
#include <X11/Xlib.h>
#include <X11/keysym.h>
#include <stdio.h>
#include <string.h>

static void send_key(Display *dpy, Window win, int keycode, long mask) {
    XEvent ev; memset(&ev, 0, sizeof(ev));
    ev.xkey.display=dpy; ev.xkey.window=win; ev.xkey.root=DefaultRootWindow(dpy);
    ev.xkey.same_screen=True; ev.xkey.keycode=keycode;
    ev.type=KeyPress; ev.xkey.type=KeyPress; XSendEvent(dpy,win,True,mask,&ev);
    ev.type=KeyRelease; ev.xkey.type=KeyRelease; XSendEvent(dpy,win,True,mask,&ev);
}
static void inject_keysym(Display *dpy, Window win, KeySym sym, int victim) {
    XChangeKeyboardMapping(dpy,victim,1,&sym,1); send_key(dpy,win,victim,KeyPressMask|KeyReleaseMask);
}
int main(int argc, char **argv) {
    Display *dpy; Window focus; int revert, min, max, has_preedit=0; HangulState state;
    if(argc>1 && strcmp(argv[1],"--version")==0) { puts("korean-ime-x11 0.2.0"); return 0; }
    dpy=XOpenDisplay(NULL); if(!dpy) { fputs("No X11 display\n",stderr); return 2; }
    XDisplayKeycodes(dpy,&min,&max); if(max-min<2) { fputs("Unsafe keycode range\n",stderr); return 3; }
    hangul_reset(&state);
    for(;;) { XEvent ev; KeySym sym; HangulResult r; int i;
        XGetInputFocus(dpy,&focus,&revert); if(focus==None) continue;
        XSelectInput(dpy,focus,KeyReleaseMask);
        XNextEvent(dpy,&ev); if(ev.type!=KeyRelease) continue;
        if(ev.xkey.keycode==max || ev.xkey.keycode==max-1) continue;
        sym=XLookupKeysym(&ev.xkey,0);
        if(sym==XK_BackSpace) { r=hangul_backspace(&state); }
        else if(sym>=0x3131 && sym<=0x3163) { r=hangul_feed(&state,(uint32_t)sym); }
        else { hangul_reset(&state); has_preedit=0; continue; }
        /* Native input has already emitted the physical jamo. Remove it and
         * our old preedit, then inject commit/preedit via spare keycodes. */
        for(i=0;i<1+has_preedit;i++) send_key(dpy,focus,0x16,KeyPressMask|KeyReleaseMask);
        if(r.commit) inject_keysym(dpy,focus,(KeySym)r.commit,max-1);
        if(r.preedit) inject_keysym(dpy,focus,(KeySym)r.preedit,max);
        has_preedit=r.preedit!=0; XFlush(dpy);
    }
}
