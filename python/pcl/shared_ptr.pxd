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
