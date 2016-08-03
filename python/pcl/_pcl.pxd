cimport _pcl_defs as cpp

cdef class PointCloud:
  cdef cpp.shared_ptr[cpp.PointCloud[cpp.PointXYZ]] _thisptr
  cdef inline cpp.shared_ptr[cpp.PointCloud[cpp.PointXYZ]] thisptr(self) nogil:
    return self._thisptr
