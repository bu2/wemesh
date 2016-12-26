cimport _pcl_defs as cpp
import cython
from cython cimport Py_buffer
import numpy as np
cimport numpy as np



cdef class PointCloud:

  def __cinit__(self, int width=-1, int height=-1, np.ndarray[float, ndim=2] arr = None):
    if width < 0:
      self._thisptr = cpp.PointCloudPtr(new cpp.PointCloud[cpp.PointXYZ]())
    elif arr:
      pass
    else:
      self._thisptr = cpp.PointCloudPtr(new cpp.PointCloud[cpp.PointXYZ](width, height))

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

  def estimate_normals(self, double radius, PointCloud surface=None):
    cdef cpp.NormalEstimation[cpp.PointXYZ, cpp.Normal] normal_estimation = cpp.NormalEstimation[cpp.PointXYZ, cpp.Normal]()
    cdef cpp.KdTreePtr tree = cpp.KdTreePtr(new cpp.KdTree[cpp.PointXYZ]())
    cdef NormalCloud normals = NormalCloud()
    normal_estimation.setInputCloud(self._thisptr)
    normal_estimation.setSearchMethod(tree)
    if surface:
      normal_estimation.setSearchSurface(surface.thisptr())
    normal_estimation.setRadiusSearch(radius)
    normal_estimation.compute(normals.thisptr().get()[0])
    return normals



cdef class NormalCloud:

  def __cinit__(self):
    self._thisptr = cpp.NormalCloudPtr(new cpp.PointCloud[cpp.Normal]())

  def __dealloc__(self):
    pass

  def __getbuffer__(self, Py_buffer *buffer, int flags):
    cdef Py_ssize_t itemsize = sizeof(self._thisptr.get().points[0].normal_x)

    self.shape[0] = self._thisptr.get().width
    self.shape[1] = self._thisptr.get().height
    self.shape[2] = 4

    self.strides[0] = <char *>&(self._thisptr.get().points[1]) - <char *>&(self._thisptr.get().points[0])
    self.strides[1] = <char *>&(self._thisptr.get().points[self._thisptr.get().width]) - <char *>&(self._thisptr.get().points[0])
    self.strides[2] = <char *>&(self._thisptr.get().points[0].normal_y) - <char *>&(self._thisptr.get().points[0].normal_x)

    buffer.buf = <char *>&(self._thisptr.get().points[0].normal_x)
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
