# -*- mode: python; python-indent-offset: 4 -*-
import sys
import os
current_dir = os.path.dirname(os.path.abspath(__file__))
if current_dir not in sys.path:
    sys.path.insert(0, current_dir)
sys.path.append(os.path.join(current_dir, 'modules/'))
from raylib_wrapper import *
logging = True

def main():
    screen_width  = 1920 >> 2 # 480
    screen_height = 1080 >> 2 # 270
    WHITE    = ColorRGB(255, 255, 255, 255)
    BLACK    = ColorRGB(  0,   0,   0, 255)
    BLANK    = ColorRGB(  0 ,  0,   0,   0)
    set_target_fps(60)
    set_exit_key(0)
    exitWindow = False
    set_config_flags(0x00000010)#Transparency for the window
    init_window(screen_width, screen_height, "TV Static")
    set_window_state(0x00000008 | 0x00010000)
    # NOTE: Loading textures must be done after init window
    cursor_texture = load_texture("Resources/mycursor.png")
    tv_texture = load_texture("Resources/tvset.png")
    #hide_cursor()
    noise_render_texture = load_render_texture(screen_width, screen_height)
    noise_texture = get_target_texture(noise_render_texture)

    # Frame counter for update timing
    frame_counter = 0
    begin_blend_mode(0)
    clearbg_col(BLANK)
    while (not exitWindow):
        if (is_key_pressed(256) or window_should_close()):
            exitWindow = True
        frame_counter += 1
        
        ##BEGIN TEXTURE##        
        begin_texture_mode(noise_render_texture)
        
        n_blocks = int(screen_width * screen_height * 0.2)
        block_size = 1
        for _ in range(n_blocks):
            x = random(25, screen_width-235)
            y = random(108, screen_height)
            ra = random(0, 100)
            rb = random(5, 15) if ra < 5 else ra
            r = 180 if rb < 10 else rb
            rand_grayscale = random(20, 150) if r < 180 else r
            #rand_grayscale = random(20, 150)
            color = ColorRGB(rand_grayscale, rand_grayscale, rand_grayscale, 255)
            draw_rect(x, y-25, block_size, block_size, color)
        
        end_texture_mode()
        ##END TEXTURE##

        ##BEGIN DRAWING##
        begin_drawing()
        
        clearbg_col(BLANK)
        draw_texture(tv_texture,    0, 0, WHITE)        
        draw_texture(noise_texture, 0, 0, ColorRGB(255,255,255,240))
        #draw_texture(cursor_texture, mouseX(), mouseY(), WHITE)
        if logging:
            if mouseDeltaX() or mouseDeltaY():
                print(f" Frame {frame_counter} | ({mouseX()}, {mouseY()})")

        end_drawing()
        ##END DRAWING##

    end_blend_mode()
    unload_texture(cursor_texture)
    unload_texture(tv_texture)
    close_window()

if __name__ == "__main__":
    main()
    exit(0)

