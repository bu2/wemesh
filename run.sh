#!/bin/bash -x

source env/bin/activate
cd paraview.app/Contents/MacOS
DYLD_LIBRARY_PATH="../../../lib:../../../OpenNI-MacOSX-x64-2.2/Redist" PYTHONPATH="../../../python:../../../env/lib/python2.7/site-packages:../../../paraview/build/lib/site-packages:../../../paraview/build/lib" ./paraview $* 2>&1 | tee run.log
cd ../../../
deactivate
