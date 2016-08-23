#!/bin/bash -x

ROOT=$PWD

QT5ROOT=$HOME/lab/qt-5.7/5.7/clang_64

JOBS=4

cd paraview
mkdir -p build
cd build
cmake -DCMAKE_BUILD_TYPE=RelWithDebInfo -DCMAKE_INSTALL_PREFIX=$ROOT -DMACOSX_APP_INSTALL_PREFIX=$ROOT -DPARAVIEW_QT_VERSION=5 -DQt5_DIR=$QT5ROOT/lib/cmake/Qt5/ -DQt5Core_DIR=$QT5ROOT/lib/cmake/Qt5Core/ -DPARAVIEW_ENABLE_PYTHON=ON .. 2>&1 | tee cmake.log
make -j$JOBS 2>&1 | tee make.log
make install 2>&1 | tee make_install.log
cd ../..

cd pcl
mkdir -p build
cd build
cmake -DCMAKE_BUILD_TYPE=RelWithDebInfo -DCMAKE_INSTALL_PREFIX=$ROOT -DOPENNI2_INCLUDE_DIRS=$ROOT/OpenNI-MacOSX-x64-2.2/Include/ -DOPENNI2_LIBRARY=$ROOT/OpenNI-MacOSX-x64-2.2/Redist/libOpenNI2.dylib .. 2>&1 | tee cmake.log
make -j$JOBS 2>&1 | tee make.log
make install 2>&1 | tee make_install.log
cd ../..

source env/bin/activate
cd python/pcl
ipython setup.py -- build_ext --inplace 2>&1 | tee build_ext.log

# UGLY FIX: Cython seems not to handle custom allocator on std::vector...
sed -E -i.old 's/const std::vector<struct pcl::PointXYZ>/const std::vector<struct pcl::PointXYZ, Eigen::aligned_allocator<struct pcl::PointXYZ> >/' _pcl.cpp
sed -E -i.old 's/boost::arg/boost::arg<1>/' _pcl.cpp
sed -E -i.old 's/boost::bind<__pyx_t_3pcl_9_pcl_defs_OpenNI2GrabberCallback>/boost::bind/' _pcl.cpp
ipython setup.py -- build_ext --inplace 2>&1 | tee build_ext.log

cd ../..
deactivate
