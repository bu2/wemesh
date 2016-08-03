cimport _pcl_defs as cpp

cimport _pcl

cdef class VoxelGrid:

  def __cinit__(self):
    self._thisptr = cpp.shared_ptr[cpp.VoxelGrid[cpp.PointXYZ]](new cpp.VoxelGrid[cpp.PointXYZ]())

  def __dealloc__(self):
    pass

  def setLeafSize(self, float x, float y, float z):
    self._thisptr.get().setLeafSize(x, y, z)

  def setInputCloud(self, _pcl.PointCloud cloud):
    self._thisptr.get().setInputCloud(cloud.thisptr())

  def filter(self):
    cdef _pcl.PointCloud cloud = _pcl.PointCloud()
    self._thisptr.get().filter(cloud._thisptr.get()[0])
    return cloud
