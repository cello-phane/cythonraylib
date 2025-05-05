# -*- mode: python; python-indent-offset: 4 -*-
import sys
import os
current_dir = os.path.dirname(os.path.abspath(__file__))
if current_dir not in sys.path:
    sys.path.insert(0, current_dir)
sys.path.append(os.path.join(current_dir, 'modules/'))
from raylib_wrapper import *
logging = True  # Set to True for mouse position logging

def main():
    screen_width  = 1920 >> 2  # 480
    screen_height = 1080 >> 2  # 270    

    set_target_fps(60)
    set_exit_key(0)
    exitWindow = False
    gl_enable(0x0BE2)
    gl_blend_func(0x0302, 0x0303)

    set_config_flags(FLAG_WINDOW_TRANSPARENT)
    
    init_window(screen_width, screen_height, "TV Static")

    set_window_state(FLAG_INTERLACED_HINT | FLAG_WINDOW_UNFOCUSED | FLAG_WINDOW_UNDECORATED | FLAG_MSAA_4X_HINT)
    
    # NOTE: Loading textures must be done after init window
    cursor_texture = load_texture("Resources/mycursor.png")
    tv_texture = load_texture("Resources/tvset.png")

    noise_render_texture = load_render_texture(screen_width, screen_height)
    noise_texture = get_target_texture(noise_render_texture)
    hide_cursor()    
    frame_counter = 0
    # begin_blend_mode(0)  # Normal blend mode

    # TV screen bounds for static
    TV_LEFT   = 25
    TV_RIGHT  = screen_width - 235
    TV_TOP    = 90
    TV_BOTTOM = screen_height  
    while (not exitWindow):
        if (is_key_pressed(256) or window_should_close()):
            exitWindow = True
            
        frame_counter += 1

        ##BEGIN TEXTURE##        
        begin_texture_mode(noise_render_texture)
        
        n_blocks = int(TV_RIGHT * TV_BOTTOM * 0.3)
        block_size = 1
        for _ in range(n_blocks):
            x  = random(0,  220)#dimensions of the
            y  = random(0 , 160)#inside of the TV (png image)
            ra = random(0, 100)
            rb = random(5, 15) if ra < 5 else ra
            r  = 200 if rb < 10 else rb
            rand_grayscale = random(20, 150) if r < 200 else r
            #rand_grayscale = random(20, 150)
            color_generated = ColorRGB(rand_grayscale, rand_grayscale, rand_grayscale, 255)
            draw_rect(x+TV_LEFT, y+TV_TOP, block_size, block_size, color_generated)
        
        end_texture_mode()
        ##END TEXTURE##
        
        ##BEGIN DRAWING##
        begin_drawing()
        
        clearbg_col(BLANK) # Clear with transparent background
        
        draw_texture(tv_texture, 0, 0, WHITE)
        draw_texture(noise_texture, 0, 5, ColorRGB(255, 255, 255, 240))
        
        # Draw cursor
        draw_texture(cursor_texture, mouseX(), mouseY(), WHITE)
        
        if logging and (mouseDeltaX() or mouseDeltaY()):
            print(f" Frame {frame_counter} | ({mouseX()}, {mouseY()})")
            
        end_drawing()
        ##END DRAWING##

    # end_blend_mode()
    
    # Clean up resources
    unload_texture(cursor_texture)
    unload_texture(tv_texture)
    close_window()

if __name__ == "__main__":
    main()
    exit(0)
