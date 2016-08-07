cdef extern from "Eigen/Eigen" namespace "Eigen" nogil:
    cdef cppclass aligned_allocator[T]:
        pass
