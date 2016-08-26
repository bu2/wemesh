cimport _pcl_defs as cpp

cimport _pcl

import threading



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
  cdef cpp.PointCloudPtr ptr
  ptr = cpp.boost.const_pointer_cast[__PointCloud, __PointCloudConst](cloud)
  _cloud.set_thisptr(ptr)
  _count += 1



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

  property current_cloud:
    def __get__(self):
      global _cloud
      return _cloud

  property count:
    def __get__(self):
      global _count
      return _count



cdef OpenNI2Grabber _grabber
_grabber_thread = None



def __start_grabber_impl__():
  global _grabber
  _grabber.start()

def start_grabber():
  global _grabber
  global _grabber_thread
  if _grabber_thread == None:
    _grabber = OpenNI2Grabber()
    _grabber_thread = threading.Thread(target=__start_grabber_impl__)
    _grabber_thread.start()
  return _grabber
