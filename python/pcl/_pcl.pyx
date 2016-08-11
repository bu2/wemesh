cimport _pcl_defs as cpp
from cython cimport Py_buffer

cdef class PointCloud:

  def __cinit__(self):
    self._thisptr = cpp.shared_ptr[cpp.PointCloud[cpp.PointXYZ]](new cpp.PointCloud[cpp.PointXYZ]())

  def __dealloc__(self):
    pass

  def __getbuffer__(self, Py_buffer *buffer, int flags):
    cdef Py_ssize_t itemsize = sizeof(self._thisptr.get().points[0].x)

    self.shape[0] = 640
    self.shape[1] = 480
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
