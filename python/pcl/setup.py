from distutils.core import setup, Extension
from Cython.Build import cythonize

ext_modules = []

_pcl_ext = Extension("_pcl",
                     sources=["_pcl.pyx"],
                     include_dirs=["../../include/pcl-1.8",
                                   "/Users/bu2/.brew/include",
                                   "/Users/bu2/.brew/include/eigen3"],
                     libraries=["pcl_common", "pcl_io"],
                     library_dirs=["../../lib"],
                     language="c++")
ext_modules.append(_pcl_ext)

_pcl_io_ext = Extension("io._io",
                        sources=["io/_io.pyx"],
                        include_dirs=["../../include/pcl-1.8",
                                      "/Users/bu2/.brew/include",
                                      "/Users/bu2/.brew/include/eigen3"],
                        libraries=["pcl_common", "pcl_io"],
                        library_dirs=["../../lib"],
                        language="c++")
ext_modules.append(_pcl_io_ext)

_pcl_filters_ext = Extension("filters._filters",
                             sources=["filters/_filters.pyx"],
                             include_dirs=["../../include/pcl-1.8",
                                           "/Users/bu2/.brew/include",
                                           "/Users/bu2/.brew/include/eigen3"],
                             libraries=["pcl_common", "pcl_filters"],
                             library_dirs=["../../lib"],
                             language="c++")
ext_modules.append(_pcl_filters_ext)

setup(name="_pcl", ext_modules=cythonize(ext_modules))
