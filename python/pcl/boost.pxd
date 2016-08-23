from libcpp cimport bool



cdef extern from "boost/smart_ptr/shared_ptr.hpp" namespace "boost" nogil:
    cdef cppclass shared_ptr[PointT]:
        shared_ptr()
        shared_ptr(PointT*)
        PointT* get()
        bool unique()
        long use_count()
        void swap(shared_ptr[PointT])
        void reset(PointT*)



cdef extern from "boost/signals2/connection.hpp" namespace "boost::signals2" nogil:
  cdef cppclass connection:
    pass



cdef extern from "boost/function.hpp" namespace "boost" nogil:
  cdef cppclass function[T]:
    pass



cdef extern from "boost/bind.hpp" namespace "boost" nogil:
  cdef struct arg:
    pass
  cdef function[T] bind[T](T callback, arg _1)