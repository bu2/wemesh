cimport _pcl_defs as cpp



cdef class OpenNI2Grabber:
  cdef cpp.boost.shared_ptr[cpp.OpenNI2Grabber] _thisptr

  cdef inline cpp.boost.shared_ptr[cpp.OpenNI2Grabber] thisptr(self) nogil:
    return self._thisptr

  cdef void start_impl(self)

ctypedef cpp.PointCloud[cpp.PointXYZ] __PointCloud
ctypedef const __PointCloud __PointCloudConst
