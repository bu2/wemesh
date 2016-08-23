cimport _pcl_defs as cpp



cdef class PointCloud:
  cdef cpp.boost.shared_ptr[cpp.PointCloud[cpp.PointXYZ]] _thisptr
  cdef inline cpp.boost.shared_ptr[cpp.PointCloud[cpp.PointXYZ]] thisptr(self) nogil:
    return self._thisptr

  cdef Py_ssize_t shape[3]
  cdef Py_ssize_t strides[3]



cdef class OpenNI2Grabber:
  cdef cpp.boost.shared_ptr[cpp.OpenNI2Grabber] _thisptr
  cdef inline cpp.boost.shared_ptr[cpp.OpenNI2Grabber] thisptr(self) nogil:
    return self._thisptr
