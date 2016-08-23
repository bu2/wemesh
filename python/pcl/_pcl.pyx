cimport _pcl_defs as cpp
import cython
from cython cimport Py_buffer
import numpy as np
cimport numpy as np



cdef class PointCloud:

  def __cinit__(self, int width=-1, int height=-1):
    if width < 0:
      self._thisptr = cpp.boost.shared_ptr[cpp.PointCloud[cpp.PointXYZ]](new cpp.PointCloud[cpp.PointXYZ]())
    else:
      self._thisptr = cpp.boost.shared_ptr[cpp.PointCloud[cpp.PointXYZ]](new cpp.PointCloud[cpp.PointXYZ](width, height))

  def __dealloc__(self):
    pass

  def __getbuffer__(self, Py_buffer *buffer, int flags):
    cdef Py_ssize_t itemsize = sizeof(self._thisptr.get().points[0].x)

    self.shape[0] = self._thisptr.get().width
    self.shape[1] = self._thisptr.get().height
    self.shape[2] = 3

    self.strides[0] = <char *>&(self._thisptr.get().points[1]) - <char *>&(self._thisptr.get().points[0])
    self.strides[1] = <char *>&(self._thisptr.get().points[self._thisptr.get().width]) - <char *>&(self._thisptr.get().points[0])
    self.strides[2] = <char *>&(self._thisptr.get().points[0].y) - <char *>&(self._thisptr.get().points[0].x)

    buffer.buf = <char *>&(self._thisptr.get().points[0].x)
    buffer.format = 'f'
    buffer.itemsize = itemsize
    buffer.len = self._thisptr.get().points.size() * 4 * itemsize
    buffer.ndim = 3
    buffer.obj = self
    buffer.readonly = 0
    buffer.shape = self.shape
    buffer.strides = self.strides
    buffer.internal = NULL
    buffer.suboffsets = NULL

  def __releasebuffer__(self, Py_buffer *buffer):
    pass

  @staticmethod
  @cython.boundscheck(False)
  @cython.wraparound(False)
  def fromarray(np.ndarray[float, ndim=2] arr, int width, int height):
    cloud = PointCloud(width, height)
    cloud_array = np.asarray(cloud)
    for line in range(0, height):
      cloud_array[:,line,:] = arr[line*width:(line+1)*width,:]
    cloud._thisptr.get().is_dense = False
    return cloud

  property points:
    def __get__(self): return self._thisptr.get().points

  property width:
    def __get__(self): return self._thisptr.get().width

  property height:
    def __get__(self): return self._thisptr.get().height

  property size:
    def __get__(self): return self._thisptr.get().size()

  property is_dense:
    def __get__(self): return self._thisptr.get().is_dense

  property is_organized:
      def __get__(self): return self._thisptr.get().isOrganized()

  def __repr__(self):
      return "<PointCloud of %d points>" % self.size

  def savePCDFile(self, cpp.string filename):
    return cpp.savePCDFile(filename, self._thisptr.get()[0])



cdef void __openni2_grabber_callback__(cpp.PointCloudPtr cloud):
  print 'New Cloud'

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
