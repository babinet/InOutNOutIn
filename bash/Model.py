#!/usr/bin/python2.7
from osgeo import ogr
wkt = "STRINGTOREPLACE"
geom = ogr.CreateGeometryFromWkt(wkt)
print "Length = %2f" % geom.Length()

