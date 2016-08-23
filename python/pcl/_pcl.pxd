cimport _pcl_defs as cpp



cdef class PointCloud:

  cdef cpp.PointCloudPtr _thisptr

  cdef inline cpp.PointCloudPtr thisptr(self) nogil:
    return self._thisptr

  cdef inline void set_thisptr(self, cpp.PointCloudPtr other) nogil:
    self._thisptr.swap(other)

  cdef Py_ssize_t shape[3]
  cdef Py_ssize_t strides[3]
