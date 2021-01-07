# InOut_OutIn
* *Environment : #/bin/bash!*
* *Requirement : gdal imagemagick geomet*

Output settings:

![Screenshot](Img/Node_Export.png)

Then
```
sudo ./drush.phar ne-export --format=JSON --file=AllNodes.txt
```

Distance parcourue (mètres) : 

```
from osgeo import ogr
wkt = "LINESTRING (599014.56614022 122720.336597501 0, 599006.884341363 122730.553142569 0, 599043.436147199 122757.459124949 0)"
geom = ogr.CreateGeometryFromWkt(wkt)
print "Length = %d" % geom.Length()
```
Distance parcourue (Toises / Pieds-de-roi) : 

Caractères INTERDITS ! :
```
" | & < >
```
