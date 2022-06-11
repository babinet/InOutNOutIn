#!/usr/bin/python
from osgeo import ogr
from osgeo import osr
source = osr.SpatialReference()
source.ImportFromEPSG(3857)

target = osr.SpatialReference()
target.ImportFromEPSG(27561)

transform = osr.CoordinateTransformation(source, target)

wkt = "STRINGTOREPLACE"
geom = ogr.CreateGeometryFromWkt(wkt)
geom.Transform(transform)
print ("Length = %d" % geom.Length())
