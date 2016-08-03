cimport _pcl_defs as cpp

cdef class PointCloud:

  def __cinit__(self):
    self._thisptr = cpp.shared_ptr[cpp.PointCloud[cpp.PointXYZ]](new cpp.PointCloud[cpp.PointXYZ]())

  def __dealloc__(self):
    pass

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

  def isOrganized(self):
    return self._thisptr.get().isOrganized()

  def savePCDFile(self, cpp.string filename):
    return cpp.savePCDFile(filename, self._thisptr.get()[0])
