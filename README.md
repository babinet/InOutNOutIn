# InOut_OutIn
* *Environment : #/bin/bash!*
* *Requirement : gdal imagemagick geomet*

Output settings:

![Screenshot](Img/Node_Export.png)

Then
```
sudo ./drush.phar ne-export --format=JSON --file=AllNodes.txt
```

Distance parcourue ellipsoid (mètres) depuis EPSG:27561 vers EPSG:4326 : 

```
from osgeo import ogr
wkt = "LINESTRING (599014.56614022 122720.336597501 0, 599006.884341363 122730.553142569 0, 599043.436147199 122757.459124949 0)"
geom = ogr.CreateGeometryFromWkt(wkt)
print "Length = %d" % geom.Length()
```
Distance parcourue en pied de roi (Charlemagne) utilisé entre 1668 et 1799 d'une longueur de 324,839 mm Toises / Pieds-de-roi / Pouces - conversion :

```
3810 métres -> 1954 Toises 5 Pieds du roi 10 Pouce(s)
```

Distance parcourue en pied de roi ancien ou carolingien utilisé avant 1668 d'une longueur de 326,596 mm Toises / Pieds-de-roi / Pouces - conversion :

Caractères INTERDITS ! :
```
" | & < >
```
