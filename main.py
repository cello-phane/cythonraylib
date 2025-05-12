# -*- mode: python; python-indent-offset: 4 -*-
import sys
import os
current_dir = os.path.dirname(os.path.abspath(__file__))
if current_dir not in sys.path:
    sys.path.insert(0, current_dir)
sys.path.append(os.path.join(current_dir, 'modules/'))
import raylib_wrapper as rl
logging = True  # Set to True for mouse position logging

def main():
    screen_width  = 1920 >> 2  # 480
    screen_height = 1080 >> 2  # 270    

    rl.set_target_fps(60)
    rl.set_exit_key(0)
    exitWindow = False
    rl.set_config_flags(rl.FLAG_WINDOW_TRANSPARENT)

    rl.init_window(screen_width, screen_height, "TV Static")

    rl.set_window_state(rl.FLAG_INTERLACED_HINT | rl.FLAG_WINDOW_UNFOCUSED | rl.FLAG_WINDOW_UNDECORATED | rl.FLAG_MSAA_4X_HINT)

    # NOTE: Loading textures must be done after init window
    cursor_texture = rl.load_texture("Resources/mycursor.png")
    tv_texture = rl.load_texture("Resources/tvset.png")

    noise_render_texture = rl.load_render_texture(screen_width, screen_height)
    noise_texture = rl.get_target_texture(noise_render_texture)
    rl.hide_cursor()    
    frame_counter = 0
    # rl.begin_blend_mode(0)  # Normal blend mode

    # TV screen bounds for static
    TV_LEFT   = 25
    TV_RIGHT  = screen_width - 235
    TV_TOP    = 90
    TV_BOTTOM = screen_height  
    while (not exitWindow):
        if (rl.is_key_pressed(256) or rl.window_should_close()):
            exitWindow = True
        rl.draw_text("A window!", 20, 20, 42, rl.WHITE)
        frame_counter += 1

        ##BEGIN TEXTURE##        
        rl.begin_texture_mode(noise_render_texture)

        n_blocks = int(TV_RIGHT * TV_BOTTOM * 0.3)
        block_size = 1
        for n in range(n_blocks):
            x  = rl.random(0,  220)#dimensions of the
            y  = rl.random(0 , 160)#inside of the TV (png image)
            ra = rl.random(0, 100)
            rb = rl.random(5, 15) if ra < 5 else ra
            r  = 200 if rb < 10 else rb
            rand_grayscale = rl.random(20, 150) if r < 200 else r
            #rand_grayscale = random(20, 150)
            color_generated = rl.ColorRGB(rand_grayscale, rand_grayscale, rand_grayscale, 255)
            #color_generated = ColorRGB(random(20, 150) if r < 200 else r,random(20, 150) if r < 200 else r,random(20, 150) if r < 200 else r,255)
            rl.draw_rect(x+TV_LEFT, y+TV_TOP, block_size, block_size, color_generated)

        rl.end_texture_mode()
        ##END TEXTURE##

        ##BEGIN DRAWING##
        rl.begin_drawing()

        rl.clearbg_col(rl.BLANK) # Clear with transparent background

        rl.draw_texture(tv_texture, 0, 0, rl.WHITE)
        rl.draw_texture(noise_texture, 0, 5, rl.ColorRGB(255, 255, 255, 240))

        # Draw cursor
        rl.draw_texture(cursor_texture, rl.mouseX(), rl.mouseY(), rl.WHITE)

        if logging and (rl.mouseDeltaX() or rl.mouseDeltaY()):
            print(f" Frame {frame_counter} | ({rl.mouseX()}, {rl.mouseY()})")

        rl.end_drawing()
        ##END DRAWING##

    # rl.end_blend_mode()

    # Clean up resources
    rl.unload_texture(cursor_texture)
    rl.unload_texture(tv_texture)
    rl.close_window()

if __name__ == "__main__":
    main()
    exit(0)
