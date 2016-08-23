from libc.stddef cimport size_t
from libcpp cimport bool
from libcpp.string cimport string
from libcpp.vector cimport vector

cimport eigen
cimport boost



cdef extern from "pcl/point_types.h" namespace "pcl":
  struct PointXYZ:
    float x
    float y
    float z



cdef extern from "pcl/point_cloud.h" namespace "pcl":
  cdef cppclass PointCloud[PointT]:
    PointCloud() except +
    PointCloud(int width, int height) except +
    vector[PointT, eigen.aligned_allocator[PointT]] points
    unsigned int width
    unsigned int height
    bool is_dense
    size_t size()
    bool isOrganized()

ctypedef boost.shared_ptr[PointCloud[PointXYZ]] PointCloudPtr
ctypedef boost.shared_ptr[PointCloud[PointXYZ]] PointCloudConstPtr



cdef extern from "pcl/io/pcd_io.h" namespace "pcl::io":
  int loadPCDFile[PointT](string filename, PointCloud[PointT] &cloud)
  int savePCDFile[PointT](string filename, PointCloud[PointT] &cloud)



ctypedef void OpenNI2GrabberCallback(PointCloudConstPtr)
cdef extern from "pcl/io/openni2_grabber.h" namespace "pcl::io":
  cdef cppclass OpenNI2Grabber:
    OpenNI2Grabber()
    boost.connection registerCallback(boost.function[OpenNI2GrabberCallback] callback)
    void start()
    void stop()



cdef extern from "pcl/filters/voxel_grid.h" namespace "pcl":
  cdef cppclass VoxelGrid[PointT]:
    VoxelGrid()
    void setLeafSize(float, float, float)
    void setInputCloud(boost.shared_ptr[PointCloud[PointT]])
    void filter(PointCloud[PointT])
