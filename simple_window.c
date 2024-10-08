#include <X11/Xlib.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h> //this is for sleep remove plz

int main(int argc, char **argv)
{
	Display *dis = XOpenDisplay(NULL);
	Display *dis2 = XOpenDisplay(":0");
	int count = ScreenCount(dis2);
	

	for(unsigned i = 0; i <= count; i++)
	{
		Screen *pointer = ScreenOfDisplay(dis, i);
		printf("\nlong: %ld \n", BlackPixel(dis, i));
		
	}
	printf("\n\n%d\n\n", count);
	
	

	XSetWindowAttributes wa = {
		.override_redirect = True,
  		.background_pixmap = ParentRelative,
		.event_mask = ButtonPressMask|ExposureMask
	};

	Window w = XCreateWindow(dis, RootWindow(dis, 0), 400, 400, 1000, 1000, 0, DefaultDepth(dis, 0), CopyFromParent, DefaultVisual(dis, 0), CWOverrideRedirect|CWBackPixmap|CWEventMask, &wa);

	XMapWindow(dis, w);

	XWindowChanges wc = {
	.x = 10,
	.y = 20,
	.width = 500,
	.height = 600,
	.border_width = 2,
	};

	

	XConfigureWindow(dis, w, 31, &wc);
	XSync(dis, False);
	sleep(6);

	XDestroyWindow(dis, w);

	XCloseDisplay(dis);

	return EXIT_SUCCESS;
	
}
