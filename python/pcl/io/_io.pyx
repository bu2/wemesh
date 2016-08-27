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
  global _grabber_mutex
  cdef cpp.PointCloudPtr ptr
  if _grabber_mutex.try_lock() != 0:
    ptr = cpp.boost.const_pointer_cast[__PointCloud, __PointCloudConst](cloud)
    _cloud.set_thisptr(ptr)
    _count += 1
    _grabber_mutex.unlock()



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

  def lock(self, blocking=True):
    global _grabber_mutex
    if blocking:
      _grabber_mutex.lock()
      return True
    else:
      return _grabber_mutex.try_lock()

  def unlock(self):
    global _grabber_mutex
    _grabber_mutex.unlock()

  property current_cloud:
    def __get__(self):
      global _cloud
      return _cloud

  property count:
    def __get__(self):
      global _count
      return _count



cdef OpenNI2Grabber _grabber
cdef cpp.boost.thread[t_start_grabber_impl] _grabber_thread
cdef cpp.boost.mutex _grabber_mutex
cdef cpp.bool _grabber_started = False



cdef void __start_grabber_impl__():
  global _grabber
  _grabber.start()

def start_grabber():
  global _grabber
  global _grabber_thread
  global _grabber_mutex
  global _grabber_started
  if not _grabber_started:
    _grabber = OpenNI2Grabber()
    _grabber_thread = cpp.boost.thread[t_start_grabber_impl](__start_grabber_impl__)
    _grabber_started = True
  return _grabber
