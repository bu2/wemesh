cimport _pcl_defs as cpp

cimport _pcl



def loadPCDFile(cpp.string filename):
  cdef _pcl.PointCloud cloud = _pcl.PointCloud()
  ret = cpp.loadPCDFile(filename, cloud.thisptr().get()[0])
  if ret == 0:
    return cloud
  else:
    return None



cdef void __openni2_grabber_callback__(cpp.PointCloudConstPtr cloud):
  pass

cdef class OpenNI2Grabber:

  def __cinit__(self):
    self._thisptr = cpp.boost.shared_ptr[cpp.OpenNI2Grabber](new cpp.OpenNI2Grabber())

  def __dealloc__(self):
    pass

  def start(self):
    cdef cpp.boost.arg _1
    cdef cpp.boost.function[cpp.OpenNI2GrabberCallback] callback = cpp.boost.bind[cpp.OpenNI2GrabberCallback](__openni2_grabber_callback__, _1)
    self._thisptr.get().registerCallback(callback)
    self._thisptr.get().start()

  def stop(self):
    self._thisptr.get().stop()
