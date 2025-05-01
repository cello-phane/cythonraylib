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
    screen_width = int(1920/4)
    screen_height = int(1080/4)
    WHITE = ColorRGB(255, 255, 255, 255)
    BLACK = ColorRGB(0, 0, 0, 255)
    BLUEGREY = ColorRGB(59, 67, 83, 255)
    
    set_target_fps(120)
    set_exit_key(0)
    exitWindow = False

    init_window(screen_width, screen_height, "TV Static")

    cursor_texture = load_texture("./Resources/mycursor.png")
    hide_cursor()
    
    noise_render_texture = load_render_texture(screen_width, screen_height)
    noise_texture = get_target_texture(noise_render_texture)

    # Frame counter for update timing
    frame_counter = 0
    
    while (not exitWindow):
        if (is_key_pressed(256) or window_should_close()):
            exitWindow = True

        frame_counter += 1

        begin_texture_mode(noise_render_texture)

        # Cover about 40% of screen with static pixels
        static_density = int(screen_width * screen_height * 0.4)
        
        for _ in range(static_density):
            x = random(0, screen_width - 1)
            y = random(0, screen_height - 1)
            rcol = random(0, int(static_density/4) % 255)
            color = ColorRGB(rcol, rcol, rcol, 255)
            draw_rect(x, y, 1, 1, color)
        
        end_texture_mode()

        begin_drawing()
        
        # Draw the static noise texture
        draw_texture(noise_texture, 0, 0, WHITE)
        
        # Draw a png as a cursor
        #draw_texture(cursor_texture, mouseX(), mouseY(), WHITE)
        
        end_drawing()

    unload_texture(cursor_texture)
    close_window()

if __name__ == "__main__":
    main()
    exit(0)
