import vtk
from vtk.numpy_interface import dataset_adapter as dsa
import numpy as np

def show(output, cloud):
    rez = np.asarray(cloud).ravel(order='K').reshape((cloud.width*cloud.height, 3))
    pts = vtk.vtkPoints()
    pts.SetData(dsa.numpyTovtkDataArray(rez, 'Points'))

    cells = vtk.vtkCellArray()
    for i in range(0,cloud.width*cloud.height):
        cells.InsertNextCell(vtk.VTK_VERTEX)
        cells.InsertCellPoint(i)

    output.SetPoints(pts)
    output.SetVerts(cells)
