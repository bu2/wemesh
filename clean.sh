#!/bin/bash -x

# CLEAN INSTALLED FILES
rm -Rfv paraview.app bin include lib share

# CLEAN C++ BUILD
rm -Rfv paraview/build
rm -Rfv pcl/build

# CLEAN CYTHON BUILD
rm -Rfv python/pcl/build
rm -fv python/pcl/_pcl.cpp
rm -fv python/pcl/_pcl.so
rm -fv python/pcl/io/_io.cpp
rm -fv python/pcl/io/_io.so
rm -fv python/pcl/filters/_filters.cpp
rm -fv python/pcl/filters/_filters.so
find ./python -type f -and -name '*.pyc' -print0 | xargs -0 rm -fv

# CLEAN OTHER FILES
find . -type f -and \( -name '*~' -o -name '.DS_Store' \) -print0 | xargs -0 rm -fv
