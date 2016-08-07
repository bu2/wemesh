from libc.stddef cimport size_t
from libcpp cimport bool
from libcpp.string cimport string
from libcpp.vector cimport vector

cimport eigen
from shared_ptr cimport shared_ptr

cdef extern from "pcl/point_types.h" namespace "pcl":
  struct PointXYZ:
    float x
    float y
    float z

cdef extern from "pcl/point_cloud.h" namespace "pcl":
  cdef cppclass PointCloud[PointT]:
    PointCloud() except +
    vector[PointT, eigen.aligned_allocator[PointT]] points
    unsigned int width
    unsigned int height
    bool is_dense
    size_t size()
    bool isOrganized()
ctypedef shared_ptr[PointCloud[PointXYZ]] PointCloudPtr

cdef extern from "pcl/io/pcd_io.h" namespace "pcl::io":
  int loadPCDFile[PointT](string filename, PointCloud[PointT] &cloud)
  int savePCDFile[PointT](string filename, PointCloud[PointT] &cloud)

cdef extern from "pcl/filters/voxel_grid.h" namespace "pcl":
  cdef cppclass VoxelGrid[PointT]:
    VoxelGrid()
    void setLeafSize(float, float, float)
    void setInputCloud(shared_ptr[PointCloud[PointT]])
    void filter(PointCloud[PointT])
