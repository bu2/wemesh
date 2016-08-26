cimport libcpp



cdef extern from "boost/smart_ptr/shared_ptr.hpp" namespace "boost" nogil:
    cdef cppclass shared_ptr[PointT]:
      shared_ptr()
      shared_ptr(PointT*)
      PointT* get()
      libcpp.bool unique()
      long use_count()
      void swap(shared_ptr[PointT])
      void reset()
      void reset(PointT*)

    cdef shared_ptr[T] const_pointer_cast[T, U](shared_ptr[U]&)




cdef extern from "boost/signals2/connection.hpp" namespace "boost::signals2" nogil:
  cdef cppclass connection:
    pass



cdef extern from "boost/function.hpp" namespace "boost" nogil:
  cdef cppclass function[T]:
    pass



cdef extern from "boost/bind.hpp" namespace "boost" nogil:
  cdef struct arg:
    pass
  cdef function[T] bind[T](T, arg)
