#!/bin/bash -x

source env/bin/activate
cd paraview.app/Contents/MacOS
DYLD_LIBRARY_PATH="../../../lib:../../../OpenNI-MacOSX-x64-2.2/Redist" PYTHONPATH="../../../python" ./paraview $* 2>&1 | tee run.log
cd ../../../
deactivate
