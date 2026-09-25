#ifndef KOREAN_IME_X11_ABI_H
#define KOREAN_IME_X11_ABI_H
typedef struct _XDisplay Display;
typedef unsigned long XID;
typedef XID Window;
typedef XID KeySym;
typedef int Bool;
typedef struct { int type; unsigned long serial; Bool send_event; Display *display; Window window, root, subwindow; unsigned long time; int x, y, x_root, y_root; unsigned int state, keycode; Bool same_screen; } XKeyEvent;
typedef union { int type; XKeyEvent xkey; long pad[24]; } XEvent;
enum { XKeyPress = 2, XKeyRelease = 3, XNone = 0, XTrue = 1 };
enum { XKeyPressMask = 1L << 0, XKeyReleaseMask = 1L << 1 };
enum { XK_BackSpace = 0xff08 };
#endif
