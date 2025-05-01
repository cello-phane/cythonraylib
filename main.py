# -*- mode: python; python-indent-offset: 4 -*-
import sys
import os
current_dir = os.path.dirname(os.path.abspath(__file__))
if current_dir not in sys.path:
    sys.path.insert(0, current_dir)
sys.path.append(os.path.join(current_dir, 'modules/'))
from raylib_wrapper import *
cursor_logging = False
def main():
    screen_width  = int(1920/12)
    screen_height = int(1080/12)
    WHITE:    	object =  ColorRGB(255, 255, 255, 255)
    RED:      	object =  ColorRGB(200, 25,   60, 255)
    GREEN:    	object =  ColorRGB(0,   228,  48, 255)
    BLUE:     	object =  ColorRGB(59,  67,  255, 255)
    GREY:     	object =  ColorRGB(100, 122, 155, 255)
    LIGHTGREY:	object =  ColorRGB(205, 205, 205, 255)
    BLUEGREY: 	object =  ColorRGB(59,  67,   83, 255)
    set_exit_key(0)
    exitWindow: bool = False

    init_window(screen_width, screen_height, "Hello from cython")
    # undecorated : 0x00000008 
    # transparent : 0x00000010
    # fullscreen  : 0x00000002
    # resizable   : 0x00000004
    # vsync hint  : 0x00000040
    set_window_state(0x00000040)

    # NOTE: Textures MUST be loaded after Window initialization (OpenGL context is required)
    # Replacing the traditional cursor with a texture of a cursor in png format
    cursor_texture = load_texture("./Resources/mycursor.png")
    hide_cursor()
    boxw = int(screen_width)
    boxh = int(screen_height)
    while (not exitWindow):
        # if Escape key(key 256) is pressed
        if (is_key_pressed(256) or window_should_close()):
            exitWindow = True;
        # clearbg_col(color=ColorRGB(59, 67, 83, 255))

        begin_drawing()
        clearbg_col(ColorRGB(59, 67, 83, 255))

        # Random noise with small rectangles(small size because its not a fast shader)
        for x in range(boxw):
            for y in range(boxh):
                rand = random(100,255)
                draw_rect(x, y, random(0,2), random(0,2), ColorRGB(rand, rand, rand, 255))
        
        # Draw the texture at the mouse location
        draw_texture(cursor_texture, mouseX(), mouseY(), ColorRGB(255, 255, 255, 255))
        if cursor_logging and (mDeltaX() or mDeltaY()):
            print("Drawing at:", mouseX(), mouseY())
        end_drawing()
        
    close_window()
if __name__ == "__main__":
    main()
    exit(0)
