cimport _pcl_defs as cpp

cdef class VoxelGrid:
  cdef cpp.shared_ptr[cpp.VoxelGrid[cpp.PointXYZ]] _thisptr
  cdef inline cpp.shared_ptr[cpp.VoxelGrid[cpp.PointXYZ]] thisptr(self) nogil:
    return self._thisptr
