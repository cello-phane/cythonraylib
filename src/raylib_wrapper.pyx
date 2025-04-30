# cython: language_level=3
# Reminder: bools are always ints in pyx modules(and voids as args can be ommitted I guess?)
import sys
import os
from libc.math cimport sin

cdef extern from "raylib.h":
    void InitWindow(int width, int height, const char *title)
    void CloseWindow()
    void BeginDrawing()
    void EndDrawing()
    void ClearBackground(Color color)
    void DrawRectangle(int posX, int posY, int width, int height, Color color)
    void DrawCircle(int centerX, int centerY, float radius, Color color)

    int WindowShouldClose()
    void WaitTime(double seconds)
    struct Color:
        int r
        int g
        int b
        int a
    struct Vector2:
        float x
        float y
    ## Input-related functions: mouse
    void ShowCursor()
    void HideCursor()
    int IsCursorHidden()
    void EnableCursor()
    void DisableCursor()
    int IsCursorOnScreen()
    ## Input Handling Functions (Module: core)
    ## Input-related functions: keyboard
    int IsKeyPressed(int key)                          # Check if a key has been pressed once
    int IsKeyPressedRepeat(int key)                    # Check if a key has been pressed again (Only PLATFORM_DESKTOP)
    int IsKeyDown(int key)                             # Check if a key is being pressed
    int IsKeyReleased(int key)                         # Check if a key has been released once
    int IsKeyUp(int key)                               # Check if a key is NOT being pressed
    int GetKeyPressed()                                # Get key pressed (keycode), call it multiple times for keys queued, returns 0 when the queue is empty
    int GetCharPressed()                               # Get char pressed (unicode), call it multiple times for chars queued, returns 0 when the queue is empty
    void SetExitKey(int key)                           # Set a custom key to exit program (default is ESC)
    ## Input-related functions: mouse
    int IsMouseButtonPressed(int button)               # Check if a mouse button has been pressed once
    int IsMouseButtonDown(int button)                  # Check if a mouse button is being pressed
    int IsMouseButtonReleased(int button)              # Check if a mouse button has been released once
    int IsMouseButtonUp(int button)                    # Check if a mouse button is NOT being pressed
    int GetMouseX()                                    # Get mouse position X
    int GetMouseY()                                    # Get mouse position Y
    Vector2 GetMousePosition()                         # Get mouse position XY
    Vector2 GetMouseDelta()                            # Get mouse delta between frames
    void SetMousePosition(int x, int y)                # Set mouse position XY
    void SetMouseOffset(int offsetX, int offsetY)      # Set mouse offset
    void SetMouseScale(float scaleX, float scaleY)     # Set mouse scaling
    float GetMouseWheelMove()                          # Get mouse wheel movement for X or Y, whichever is larger
    Vector2 GetMouseWheelMoveV()                       # Get mouse wheel movement for both X and Y
    void SetMouseCursor(int cursor)                    # Set mouse cursor

    struct Image:
        int width
        int height
        int mipmaps
        int format
    struct Texture:
        unsigned int id
        int width
        int height
        int mipmaps
        int format;
    struct RenderTexture:
        unsigned int id
        Texture texture
        Texture depth

    # Image, pixel data stored in CPU memory (RAM)
    Image LoadImage(const char *fileName)
    Texture LoadTexture(const char *fileName)
    void UnloadImage(Image image)
    Texture LoadTextureFromImage(Image image)
    void DrawTexture(Texture texture, int posX, int posY, Color tint)
    void UnloadTexture(Texture texture)
    void ImageFormat(Image *image, int newFormat)

    RenderTexture LoadRenderTexture(int width, int height)
    void BeginTextureMode(RenderTexture target)              # Begin drawing to render texture
    void EndTextureMode()                                  # Ends drawing to render texture	    

cdef double sindf(double x):
    return sin(x)

def sinf(float x):
    return sindf(x)

def set_exit_key(int key):
    SetExitKey(key)

def mouseX():
    return GetMouseX()

def mouseY():
    return GetMouseY()

def mDeltaX():
    return GetMouseDelta().x

def mDeltaY():
    return GetMouseDelta().y

def window_should_close():
    return WindowShouldClose()

def init_window(int w, int h, str title):
    InitWindow(w, h, bytes(title, "ascii"))

def close_window():
    CloseWindow()

def begin_drawing():
    BeginDrawing()

def end_drawing():
    EndDrawing()

def wait():
    WaitTime(2.0)

# To create a Color in "pure" Python context
# (Color is a struct specific to the C api so it needs to be wrapped in this pyx)

def ColorRGB(int r, int g, int b, int a):
    return Color(r, g, b, a)

def clearbg(int r=255, int b=255, int g=255, int a=255):
    ClearBackground(ColorRGB(r, b, g, a))

def clearbg_col(Color color):
    ClearBackground(color)

def draw_rect(int x, int y, int w, int h, Color color):
    DrawRectangle(x, y, w, h, color)

def draw_circle(int center_x, int center_y, int radius, Color color):
    DrawCircle(center_x, center_y, radius, color)

def show_cursor():
    ShowCursor()

def hide_cursor():
    HideCursor()

def is_cursor_hidden():
    IsCursorHidden()

def enable_cursor():
    EnableCursor()

def disable_cursor():
    DisableCursor()

def is_cursor_on_screen():
    IsCursorOnScreen()

def is_key_pressed(int key):
    IsKeyPressed(key)

def is_key_pressed_repeat(int key):
    IsKeyPressedRepeat(key)

def is_key_down(int key):
    IsKeyDown(key)

def is_key_released(int key):
    IsKeyReleased(key)

def is_key_up(int key):
    IsKeyUp(key)

def get_key_pressed():
    return GetKeyPressed()

def get_char_pressed():
    return GetCharPressed()

## Input-related functions: mouse
def is_mouse_button_pressed(int button):
    IsMouseButtonPressed(button)

def is_mouse_button_down(int button):
    IsMouseButtonDown(button)

def is_mouse_button_released(int button):
    IsMouseButtonReleased(button)

def is_mouse_button_up(int button):
    IsMouseButtonUp(button)

def set_mouse_pos(int x, int y):
    SetMousePosition(x, y)

def set_mouse_scale(float scaleX, float scaleY):
    SetMouseScale(scaleX, scaleY)

def set_mouse_cursor(int cursor):
    SetMouseCursor(cursor)

def set_mouse_offset(int offsetX, int offsetY):
    SetMouseOffset(offsetX, offsetY)

def get_mouse_wheel_move():
    return GetMouseWheelMove()

def get_mouse_wheel_movev():
    return GetMouseWheelMoveV()

def load_render_tex(int w, int h):
    return LoadRenderTexture(w, h)

def begin_texmode(RenderTexture target):
    BeginTextureMode(target)

def end_texmode():
    EndTextureMode()

def draw_texture(Texture tex, int x, int y, Color col):
    DrawTexture(tex, x, y, col)

def unload_texture(Texture texture):
    UnloadTexture(texture)

def unload_image(Image img):
    UnloadImage(img)

def load_image(str file_path):
    return LoadImage(file_path.encode('utf-8'))

def load_texture(str file_path):
    return LoadTextureFromImage(LoadImage(file_path.encode('utf-8')))
