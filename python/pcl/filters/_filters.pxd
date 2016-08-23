cimport _pcl_defs as cpp

cdef class VoxelGrid:
  cdef cpp.boost.shared_ptr[cpp.VoxelGrid[cpp.PointXYZ]] _thisptr
  cdef inline cpp.boost.shared_ptr[cpp.VoxelGrid[cpp.PointXYZ]] thisptr(self) nogil:
    return self._thisptr
