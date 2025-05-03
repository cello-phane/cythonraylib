from setuptools import setup, Extension
from Cython.Build import cythonize
import platform
import os

# Platform-specific settings
if platform.system() == "Windows":
    libraries = ["raylib", "opengl32", "gdi32", "winmm"]
    library_dirs = ["C:/Users/admin/py/cythons/raylib/lib"]
    include_dirs = ["C:/Users/admin/py/cythons/raylib/include"]
    extra_compile_args = []
    extra_link_args = []
else:  # Linux/Mac
    libraries = ["raylib", "m", "GL"]
    library_dirs = ["/usr/lib64", "/usr/X11R7/lib64", "/usr/local/lib64" if "64" in platform.machine() else "/usr/local/lib"]
    include_dirs = ["/usr/include", "/usr/X11R7/include", "/usr/local/include/raylib"]
    extra_compile_args = []
    extra_link_args = []

extensions = [
    # Extension(
    #     "gl_wrapper",
    #     ["src/gl_wrapper.pyx"],
    #     libraries=["GL"],
    #     library_dirs=["/usr/lib64", "/usr/X11R7/lib64"],
    #     include_dirs=["/usr/include", "/usr/X11R7/include"],
    #     extra_compile_args=extra_compile_args,
    #     extra_link_args=extra_link_args,
    # ),
    Extension(
        "raylib_wrapper",
        ["src/raylib_wrapper.pyx"],
        libraries=libraries,
        library_dirs=library_dirs,
        include_dirs=include_dirs,
        extra_compile_args=extra_compile_args,
        extra_link_args=extra_link_args,
    ),
]

setup(
    name="raylib_wrapper",
    ext_modules=cythonize(extensions)
)
