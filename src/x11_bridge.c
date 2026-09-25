/* Guarded Kindle X11 bridge; Xlib is dynamically loaded for koxtoolchain. */
#include "hangul_core.h"
#include "x11_abi.h"
#include <dlfcn.h>
#include <stdio.h>
#include <string.h>
typedef struct { Display *(*open_display)(const char *); int (*display_keycodes)(Display *,int *,int *); int (*get_input_focus)(Display *,Window *,int *); int (*select_input)(Display *,Window,long); int (*next_event)(Display *,XEvent *); KeySym (*lookup_keysym)(XKeyEvent *,int); int (*change_keyboard_mapping)(Display *,int,int,KeySym *,int); int (*send_event)(Display *,Window,Bool,long,XEvent *); int (*flush)(Display *); } X11Api;
static int load_x11(void **handle, X11Api *api) {
    *handle=dlopen("libX11.so.6",RTLD_NOW|RTLD_LOCAL); if(!*handle) return 0;
#define LOAD(field,name) do { *(void **)(&api->field)=dlsym(*handle,name); if(!api->field)return 0; } while(0)
    LOAD(open_display,"XOpenDisplay"); LOAD(display_keycodes,"XDisplayKeycodes"); LOAD(get_input_focus,"XGetInputFocus"); LOAD(select_input,"XSelectInput"); LOAD(next_event,"XNextEvent"); LOAD(lookup_keysym,"XLookupKeysym"); LOAD(change_keyboard_mapping,"XChangeKeyboardMapping"); LOAD(send_event,"XSendEvent"); LOAD(flush,"XFlush");
#undef LOAD
    return 1;
}
static void send_key(X11Api *x,Display *d,Window w,int code,long mask) { XEvent e; memset(&e,0,sizeof(e)); e.xkey.display=d;e.xkey.window=w;e.xkey.keycode=(unsigned int)code;e.xkey.same_screen=XTrue;e.type=XKeyPress;e.xkey.type=XKeyPress;x->send_event(d,w,XTrue,mask,&e);e.type=XKeyRelease;e.xkey.type=XKeyRelease;x->send_event(d,w,XTrue,mask,&e); }
static void inject(X11Api *x,Display *d,Window w,KeySym sym,int code) { x->change_keyboard_mapping(d,code,1,&sym,1);send_key(x,d,w,code,XKeyPressMask|XKeyReleaseMask); }
int main(int argc,char **argv) {
    void *lib;X11Api x;Display *d;Window w;int revert,min,max,preedit=0;HangulState s;
    if(argc>1&&strcmp(argv[1],"--version")==0){puts("korean-ime-x11 0.2.0");return 0;}
    if(!load_x11(&lib,&x)){fputs("X11 library/ABI unavailable\n",stderr);return 2;}
    d=x.open_display(NULL);if(!d){fputs("No X11 display\n",stderr);return 2;}x.display_keycodes(d,&min,&max);if(max-min<2)return 3;hangul_reset(&s);
    for(;;){XEvent e;KeySym sym;HangulResult r;int i;x.get_input_focus(d,&w,&revert);if(w==XNone)continue;x.select_input(d,w,XKeyReleaseMask);x.next_event(d,&e);if(e.type!=XKeyRelease)continue;if(e.xkey.keycode==(unsigned int)max||e.xkey.keycode==(unsigned int)(max-1))continue;sym=x.lookup_keysym(&e.xkey,0);if(sym==XK_BackSpace)r=hangul_backspace(&s);else if(sym>=0x3131&&sym<=0x3163)r=hangul_feed(&s,(uint32_t)sym);else{hangul_reset(&s);preedit=0;continue;}for(i=0;i<1+preedit;i++)send_key(&x,d,w,0x16,XKeyPressMask|XKeyReleaseMask);if(r.commit)inject(&x,d,w,(KeySym)r.commit,max-1);if(r.preedit)inject(&x,d,w,(KeySym)r.preedit,max);preedit=r.preedit!=0;x.flush(d);}
}
