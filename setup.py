from setuptools import setup, Extension
from Cython.Build import cythonize
import platform
import os

# If using mingw, this flag must be passed too when running this script: python setup.py build --compiler=mingw32 
# if static lib is available
static_lib_path = os.path.abspath("libraylib.a")

# Platform-specific settings
if platform.system() == "Windows":
    # Add(Uncomment line) the below if linking with shared(dyanmic) .lib file
    #libraries = ["raylib"] 
    libraries = ["opengl32", "gdi32", "winmm", "user32", "shell32"]
	# Change path according to where raylib lib and include are located
    library_dirs = ["C:/Users/admin/py/cythonraylib/raylib/lib", "C:/raylib/raylib/src"]
    include_dirs = ["C:/Users/admin/py/cythonraylib/raylib/include", "C:/raylib/raylib/src"]
    extra_compile_args = []
    extra_link_args = []
else:  # Linux/Mac
    libraries = ["raylib", "m", "GL"]
	# Change path according to where raylib lib and include are located, and also X11 if that needs to be specified for linking
    library_dirs = ["/usr/lib64", "/usr/X11R7/lib64", "/usr/local/lib64" if "64" in platform.machine() else "/usr/local/lib"]
    include_dirs = ["/usr/include", "/usr/X11R7/include", "/usr/local/include/raylib"]
    extra_compile_args = []
    extra_link_args = []

extensions = [
    Extension(
        "raylib_wrapper",
        ["src/raylib_wrapper.pyx"],
        libraries=libraries,
        library_dirs=library_dirs,
        include_dirs=include_dirs,
        extra_compile_args=extra_compile_args,
        extra_link_args=extra_link_args,
	# Use extra_objects to link the static library directly
	extra_objects=[static_lib_path],
    ),
]

setup(
    name="raylib_wrapper",
    ext_modules=cythonize(extensions)
)
