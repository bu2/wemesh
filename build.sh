#!/bin/bash -x

ROOT=$PWD

QT5ROOT=$HOME/lab/qt-5.6/5.6/clang_64

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

# UGLY FIX: hack code to handle cases that Cython can't...
sed -i.old 's/const std::vector<struct pcl::PointXYZ>/const std::vector<struct pcl::PointXYZ, Eigen::aligned_allocator<struct pcl::PointXYZ> >/' _pcl.cpp
ipython setup.py -- build_ext --inplace 2>&1 | tee build_ext.log
sed -i.old 's/boost::arg/boost::arg<1>/' io/_io.cpp
sed -i.old 's/boost::bind<__pyx_t_9_pcl_defs_OpenNI2GrabberCallback>/boost::bind/' io/_io.cpp
sed -i.old 's/typedef boost::shared_ptr<pcl::PointCloud<struct pcl::PointXYZ> >  __pyx_t_9_pcl_defs_PointCloudConstPtr;/typedef boost::shared_ptr<pcl::PointCloud<struct pcl::PointXYZ> const > __pyx_t_9_pcl_defs_PointCloudConstPtr;/' io/_io.cpp
sed -i.old 's/typedef boost::shared_ptr<pcl::PointCloud<struct pcl::PointXYZ> >  __pyx_t_9_pcl_defs_PointCloudConstPtrRef;/typedef boost::shared_ptr<pcl::PointCloud<struct pcl::PointXYZ> const > const \& __pyx_t_9_pcl_defs_PointCloudConstPtrRef;/' io/_io.cpp
sed -i.old 's/boost::thread<__pyx_t_3pcl_2io_3_io_t_start_grabber_impl>/boost::thread/' io/_io.cpp
ipython setup.py -- build_ext --inplace 2>&1 | tee build_ext.log


cd ../..
deactivate
