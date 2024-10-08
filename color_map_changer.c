#include <stdio.h>
#include <unistd.h>
#include <xcb/xcb.h>
#include <stdlib.h>

int main(void)
{

	xcb_connection_t *c;
	xcb_screen_t *screen;
	xcb_colormap_t colormap;
	xcb_window_t win;
	xcb_window_t win2;

	//grab default colormap
	c = xcb_connect(NULL, NULL);

	screen = xcb_setup_roots_iterator(xcb_get_setup(c)).data;

	colormap = screen->default_colormap;

	uint32_t values[] = {colormap};

	//create random window

	win = xcb_generate_id(c);
	xcb_create_window	(c,
	                         XCB_COPY_FROM_PARENT,
                                 win,
                                 screen->root,
                                 0, 0,
                                 150, 150,
                                 10,
                                 XCB_WINDOW_CLASS_INPUT_OUTPUT,
                                 screen->root_visual,
                                 XCB_CW_COLORMAP,
                                 values);

	//create color map

	xcb_colormap_t ourColorMap;

	ourColorMap = xcb_generate_id(c);

	xcb_create_colormap(c, XCB_COLORMAP_ALLOC_ALL, ourColorMap, win, screen->root_visual);

	//assign colors?

	xcb_alloc_color_reply_t *rep = xcb_alloc_color_reply(c, xcb_alloc_color(c, ourColorMap, 2000, 0, 0), NULL);
	rep = xcb_alloc_color_reply(c, xcb_alloc_color(c, ourColorMap, 0, 200, 0), NULL);
	rep = xcb_alloc_color_reply(c, xcb_alloc_color(c, ourColorMap, 0, 0, 0), NULL);

	//second window?

	unsigned int cw_map[] = { ourColorMap }; 
	win2 = xcb_generate_id(c);
	xcb_create_window	(c,
				 XCB_COPY_FROM_PARENT,
				 win2,
				 win,
				 0, 0,
				 150, 150,
				 10,
				 XCB_WINDOW_CLASS_INPUT_OUTPUT,
				 screen->root_visual,
				 XCB_CW_COLORMAP,
				 cw_map);




        xcb_map_window(c, win);
	xcb_map_window(c, win2);

        xcb_flush(c);

	pause();

	free(rep);

	return 0;

}

