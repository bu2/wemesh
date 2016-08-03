cimport _pcl_defs as cpp

cimport _pcl

def loadPCDFile(cpp.string filename):
  cdef _pcl.PointCloud cloud = _pcl.PointCloud()
  ret = cpp.loadPCDFile(filename, cloud.thisptr().get()[0])
  if ret == 0:
    return cloud
  else:
    return None
