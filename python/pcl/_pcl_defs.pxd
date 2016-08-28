from libc.stddef cimport size_t
from libcpp cimport bool
from libcpp.string cimport string
from libcpp.vector cimport vector

cimport eigen
cimport boost



cdef extern from "pcl/point_types.h" namespace "pcl" nogil:
  struct PointXYZ:
    float x
    float y
    float z

  struct Normal:
    float normal_x
    float normal_y
    float normal_z
    float curvature



cdef extern from "pcl/point_cloud.h" namespace "pcl" nogil:
  cdef cppclass PointCloud[PointT]:
    PointCloud() except +
    PointCloud(PointCloud[PointT] other) except +
    PointCloud(int width, int height) except +
    vector[PointT, eigen.aligned_allocator[PointT]] points
    unsigned int width
    unsigned int height
    bool is_dense
    size_t size()
    bool isOrganized()

ctypedef boost.shared_ptr[PointCloud[PointXYZ]] PointCloudPtr
ctypedef boost.shared_ptr[PointCloud[PointXYZ]] PointCloudConstPtr
ctypedef boost.shared_ptr[PointCloud[PointXYZ]] PointCloudConstPtrRef

ctypedef boost.shared_ptr[PointCloud[Normal]] NormalCloudPtr



cdef extern from "pcl/search/kdtree.h" namespace "pcl::search":
  cdef cppclass KdTree[PointT]:
    KdTree()

ctypedef boost.shared_ptr[KdTree[PointXYZ]] KdTreePtr



cdef extern from "pcl/features/normal_3d.h" namespace "pcl" nogil:
  cdef cppclass NormalEstimation[PointT, NormalT]:
    NormalEstimation()
    void setInputCloud(PointCloudPtr)
    void setSearchMethod(KdTreePtr)
    void setRadiusSearch(double)
    void compute(PointCloud[NormalT])



cdef extern from "pcl/io/pcd_io.h" namespace "pcl::io" nogil:
  int loadPCDFile[PointT](string filename, PointCloud[PointT] &cloud) except +
  int savePCDFile[PointT](string filename, PointCloud[PointT] &cloud) except +



ctypedef void OpenNI2GrabberCallback(PointCloudConstPtrRef) nogil
cdef extern from "pcl/io/openni2_grabber.h" namespace "pcl::io" nogil:
  cdef cppclass OpenNI2Grabber:
    OpenNI2Grabber() except +
    boost.connection registerCallback(boost.function[OpenNI2GrabberCallback] callback) except +
    void start() except +
    void stop() except +



cdef extern from "pcl/filters/voxel_grid.h" namespace "pcl" nogil:
  cdef cppclass VoxelGrid[PointT]:
    VoxelGrid() except +
    void setLeafSize(float, float, float) except +
    void setInputCloud(boost.shared_ptr[PointCloud[PointT]]) except +
    void filter(PointCloud[PointT]) except +
