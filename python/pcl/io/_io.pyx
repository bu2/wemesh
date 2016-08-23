cimport _pcl_defs as cpp

cimport _pcl



def loadPCDFile(cpp.string filename):
  cdef _pcl.PointCloud cloud = _pcl.PointCloud()
  ret = cpp.loadPCDFile(filename, cloud.thisptr().get()[0])
  if ret == 0:
    return cloud
  else:
    return None



cdef _pcl.PointCloud _cloud = _pcl.PointCloud()
cdef int _count = 0

cdef void __openni2_grabber_callback__(cpp.PointCloudConstPtrRef cloud) nogil:
  global _cloud
  global _count
  _cloud.set_thisptr(cpp.boost.const_pointer_cast[__PointCloud, __PointCloudConst](cloud))
  _count += 1

cdef class OpenNI2Grabber:

  def __cinit__(self):
    self._thisptr = cpp.boost.shared_ptr[cpp.OpenNI2Grabber](new cpp.OpenNI2Grabber())

  def __dealloc__(self):
    pass

  cdef void start_impl(self):
    cdef cpp.boost.arg _1
    cdef cpp.boost.function[cpp.OpenNI2GrabberCallback] callback = cpp.boost.bind[cpp.OpenNI2GrabberCallback](__openni2_grabber_callback__, _1)
    self._thisptr.get().registerCallback(callback)
    self._thisptr.get().start()

  def start(self):
    self.start_impl()

  def stop(self):
    self._thisptr.get().stop()

  property current_cloud:
    def __get__(self):
      global _cloud
      return _cloud

  property count:
    def __get__(self):
      global _count
      return _count
