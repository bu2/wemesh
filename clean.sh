#!/bin/bash -x

rm -Rfv paraview.app bin include lib share

rm -Rfv paraview/build
rm -Rfv pcl/build

find . -type f -and -name '*~' -print0 | xargs -0 rm -fv

