# cython: language_level=3
# Reminder: bools are always ints in pyx modules(and voids as args can be ommitted I guess?)
import sys
import os
from libc.math cimport sin

cdef extern from "GL/gl.h":
    void glEnable(unsigned int cap)
    void glBlendFunc(unsigned int sfactor, unsigned int dfactor)
def gl_enable(unsigned int cap):
    glEnable(cap)
    
def gl_blend_func(unsigned int sfactor, unsigned int dfactor):
    glBlendFunc(sfactor, dfactor)

cdef extern from "raylib.h":
    void InitWindow(int width, int height, const char *title)
    void CloseWindow()
    void BeginBlendMode(int mode)
    void EndBlendMode()
    void BeginDrawing()
    void EndDrawing()
    void ClearBackground(Color color)
    void DrawRectangle(int posX, int posY, int width, int height, Color color)
    void DrawCircle(int centerX, int centerY, float radius, Color color)
    int GetRandomValue(int min, int max)
    int WindowShouldClose()
    void WaitTime(double seconds)
    void SetTargetFPS(int fps)
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
    int IsKeyPressed(int key)
    int IsKeyPressedRepeat(int key)
    int IsKeyDown(int key)
    int IsKeyReleased(int key)
    int IsKeyUp(int key)
    int GetKeyPressed()
    int GetCharPressed()
    void SetExitKey(int key)
    ## Input-related functions: mouse
    int IsMouseButtonPressed(int button)
    int IsMouseButtonDown(int button)
    int IsMouseButtonReleased(int button)
    int IsMouseButtonUp(int button)
    int GetMouseX()
    int GetMouseY()
    Vector2 GetMousePosition()
    Vector2 GetMouseDelta()
    void SetMousePosition(int x, int y)
    void SetMouseOffset(int offsetX, int offsetY)
    void SetMouseScale(float scaleX, float scaleY)
    float GetMouseWheelMove()
    Vector2 GetMouseWheelMoveV()
    void SetMouseCursor(int cursor)

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
    # Begin drawing to render texture
    void BeginTextureMode(RenderTexture target)
    # Ends drawing to render texture  
    void EndTextureMode()                       
    void SetWindowState(unsigned int flags)
    # Configures window to be transparent
    void SetConfigFlags(unsigned int flags)

cdef double sindf(double x):
    return sin(x)

def sinf(float x):
    return sindf(x)

def random(int min, int max):
    return GetRandomValue(min, max)

def set_target_fps(int fps):
    SetTargetFPS(fps)

def set_exit_key(int key):
    SetExitKey(key)

def mouseX():
    return GetMouseX()

def mouseY():
    return GetMouseY()

def mouseDeltaX():
    return GetMouseDelta().x

def mouseDeltaY():
    return GetMouseDelta().y

def window_should_close():
    return WindowShouldClose()

def init_window(int w, int h, str title):
    InitWindow(w, h, bytes(title, "ascii"))

def close_window():
    CloseWindow()

def begin_blend_mode(int mode):
    BeginBlendMode(mode)

def end_blend_mode():
    EndBlendMode()

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

def load_render_texture(int w, int h):
    return LoadRenderTexture(w, h)

def begin_texture_mode(RenderTexture target):
    BeginTextureMode(target)

def end_texture_mode():
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

def set_window_state(unsigned int flags):
    SetWindowState(flags)

def set_config_flags(unsigned int flags):
    SetConfigFlags(flags)

def get_target_texture(RenderTexture target):
    return target.texture

WHITE	   = Color(255, 255, 255, 255)
PURPLE     = Color(200, 122, 255, 255)
LIGHTGRAY  = Color(200, 200, 200, 255)
GRAY       = Color(130, 130, 130, 255)
DARKGRAY   = Color(80, 80, 80, 255   )
YELLOW     = Color(253, 249, 0, 255  )
GOLD       = Color(255, 203, 0, 255  )
ORANGE     = Color(255, 161, 0, 255  )
PINK       = Color(255, 109, 194, 255)
RED        = Color(230, 41, 55, 255  )
MAROON     = Color(190, 33, 55, 255  )
GREEN      = Color(0, 228, 48, 255   )
LIME       = Color(0, 158, 47, 255   )
DARKGREEN  = Color(0, 117, 44, 255   )
SKYBLUE    = Color(102, 191, 255, 255)
BLUE       = Color(0, 121, 241, 255  )
DARKBLUE   = Color(0, 82, 172, 255   )
PURPLE     = Color(200, 122, 255, 255)
VIOLET     = Color(135, 60, 190, 255 )
DARKPURPLE = Color(112, 31, 126, 255 )
BEIGE      = Color(211, 176, 131, 255)
BROWN      = Color(127, 106, 79, 255 )
DARKBROWN  = Color(76, 63, 47, 255   )
BLACK      = Color(0, 0, 0, 255      )
BLANK      = Color(0, 0, 0, 0        )
MAGENTA    = Color(255, 0, 255, 255  )
RAYWHITE   = Color(245, 245, 245, 255)
