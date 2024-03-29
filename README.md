# InOut_OutIn
* *Environment : #/bin/bash!*
* *Requirement : gdal imagemagick geomet gpsbabel bc inotify-tools*

Output settings:

![Screenshot](Img/Node_Export.png)

Then

```
sudo drush ne-export --format=JSON --file=AllNodes.txt
```

Or, with spécific content type. Here image

```
sudo drush ne-export --type=image --format=JSON --file=AllImages.txt
```
Import Images

```
sudo drush node-export-import --file=AllImages.tx
```
Export NodeID

```
sudo drush node-export-export 45 46 47 --file=filename
```

https://www.drupal.org/project/project_module

Export All Taxonomies TID & Names pipe separated

```
sudo drush taxocsv-export all --delimiter="|" tid
```

Exported :
```
taxocsv.csv
```

Backtrace

```
drush watchdog-show --extended --tail
```

From PHP :

```
shell_exec("./drush.phar node-export-export '{$node->nid}' --format=JSON --file=echo.txt");
```

Resave all existing terms for a vocabulay name eg. "voie_lieu"


```
drush php-eval '$v = taxonomy_vocabulary_machine_name_load("voie_lieu"); $ts = taxonomy_get_tree($v->vid, 0, NULL, TRUE); foreach ($ts as $t) {taxonomy_term_save($t);}'
```


Distance parcourue ellipsoid (mètres) depuis EPSG:27561 vers EPSG:4326 : 

```
from osgeo import ogr
wkt = "LINESTRING (599014.56614022 122720.336597501 0, 599006.884341363 122730.553142569 0, 599043.436147199 122757.459124949 0)"
geom = ogr.CreateGeometryFromWkt(wkt)
print "Length = %2f" % geom.Length()
```
Distance parcourue en pied de roi (Charlemagne) utilisé entre 1668 et 1799 d'une longueur de 324,839 mm Toises / Pieds-de-roi / Pouces - conversion :

```
3810 métres -> 1954 Toises 5 Pieds du roi 10 Pouce(s)
```

Distance parcourue en pied de roi ancien ou carolingien utilisé avant 1668 d'une longueur de 326,596 mm Toises / Pieds-de-roi / Pouces - conversion :

Caractères INTERDITS dans le nom  .kml :
```
" | & < > <- -> /\ \/ 
```
Caractères OK
```
★ • ↓ ↑ ← → 
```
Awk tid type_de_consolidation
```
cat NodePoi.csv | awk -F'field_type_de_consolidation' '{print $2}' |  awk -F'tid'\'' => '\'''  '{print $2}' | awk -F''\'',' '{print $1}'|awk '!/./ || !seen[$0]++'|awk 'NF'
```

print a map in a template :
```
<?php $map = openlayers_map_load('igc_hd');
$output = openlayers_render_map($map->data,$map->name);
print $output; ?>
```

```
$map = openlayers_map_load('your_map');
$map->data['layer_activated']['your_layer'] = 'your_layer';
$map->data['layers']['your_layer'] = 'your_layer';
$map->data['behaviors']['openlayers_behavior_zoomtolayer']['zoomtolayer']['your_layer'] = 'your_layer';    
$output = openlayers_render_map($map->data,$map->name);
```


Movie to gif :
```
ffmpeg -i mymovie.mp4 -vf "fps=10,scale=1080:-1:flags=lanczos" -c:v pam -f image2pipe - | convert -delay 10 - -loop 0 -layers optimize MyOutput.gif
```

Cut image in 4 equale quadrant :

```
convert image.tif -resize 50% -crop 2x2@ out_%02d.tif
```


Import csv for POIs Images and Access type

```
./drush feeds-import -y point_dinteret_automatic_update --file=a.csv
```


Crontab generator : https://crontab.guru

Eexport video timestamp : 

psql -d ladb

```
COPY movie_timestamps TO '/var/lib/postgresql/Timestamp_export.csv' DELIMITER '|' CSV HEADER;
```


## Procedure to import Nodes with geotags
1 import taxonomies via feeds
Remove duplicate rows before importing Taxonnomy

```
cat ___TEST.txt | awk '!seen[$0]++' > ___TEST_NO_DUPES.txt
```

2 import nodes via feeds

awk print only rows if $2 is empty :

```
awk -F'|' '$2==""'
```

awk remove rows if $2 is empty :

```
awk -F'|' '$2!=""'
```

awk print rows if $1 start by 77  :
```
awk '$1 ~ /^ *77/'
```

awk - split csv and keep headers on each chunks

```
awk -v m=10 '
    (NR==1){h=$0;next}
    (NR%m==2) { close(f); f=sprintf("%s.%0.5d",FILENAME,++c); print h > f }
    {print > f}' ACCES.CSV.csv
```
awk remove remove duplicate rows from two files, but keep one in the dest file

```
awk 'FNR==NR{a[$1$2]=$0; print} !($1$2 in a) {print}' source1 source2 > output
```

geomet WKT export 

```
geomet --wkt 
```

Remove exif orientation from image

```
convert -strip source.jpg dest.jpg
```
# awk 

Find duplicate in the collumn 31

```
awk -F'|' '{print $31}' file
```

Search variable in $3 and $6

```
awk -F'|' -v "le_nom_complet"="$Title_Name" '$3=='le_nom_complet'' Cleaned_db/title.basics_movie.csv | awk -F'|' -v "year"="$Year" '$6=='year'' > ../.Temp.film
```


### print collumn based on header name

Separator: |
Output Separator |
prevent empty cells twice if columns are tagent 
```
sed 's/||/THIS_IS_AN_EMPTY_CELL/g'|sed 's/||/THIS_IS_AN_EMPTY_CELL/g'
```
print only column Filename and MapCentroid

Sourc :
```
MyCSV=$(echo 'Filename|nodetitle|MapCentroid
My_file.tif|Mon TitreA|260098.642816645 6247162.50356738
My_file2.tif|Mon TitreB|261008.459752008 6246554.12886658') 

echo "$MyCSV" | awk -F'|' 'NR==1 {for (i=1; i<=NF; i++) {f[$i] = i}}; { print $(f["Filename"]), $(f["MapCentroid"]) }' OFS='|' |sed 's/THIS_IS_AN_EMPTY_CELL//g' > output.csv

```

Output :

```
Filename|MapCentroid
My_file.tif|260098.642816645 6247162.50356738
My_file2.tif|261008.459752008 6246554.12886658
```

Export WFS Assemblage and get NID

```
sudo drush ne-export --type=planche_wfs --file=WFS_Assemblage.txt
```
Then use KonvertExport.sh 


## Bash
Disable globbing and ignore spaces : process line by line in a loop

```
IFS=$'\n'       # Processing direcory
set -f          # disable globbing
```


HTTP2 SETUP
```
https://gist.github.com/GAS85/38eb5954a27d64ae9ac17d01bfe9898c
```


## ExifTool 
Remove Keywords
```
exiftool -r -overwrite_original -keywords= 25-50-1988.tif
```
Remove Keywords and a some new
```
exiftool -r -overwrite_original -keywords= -keywords="new keywords" 25-50-1988.tif
```
Add keywords to existing
```
exiftool -keywords+="ONE NEW KEYVORD LINE" 25-50-1988.tif
```
with option -m unlimited length
```
exiftool -m -keywords="ONE NEW KEYVORD Very Very LOOOOONG LINE ONE NEW KEYVORD Very Very LOOOOONG LINE ONE NEW KEYVORD Very Very LOOOOONG LINE ONE NEW KEYVORD Very Very LOOOOONG LINE" 25-50-1988.tif
```
Artist
```
exiftool -artist="sous-paris.com"
```

Sofware

```
exiftool -Software="kta2geo" 25-50-1988.tif
```
Clear all tags
```
exiftool -all= 25-50-1988.tif
```



Since ExifTool 12.36 it is possible to directly set Lat Lon EPSG:4326 (Notice the order first Lat then Lon)

```
exiftool -gpsposition="48.85709456183028, 2.3409128685467" the_file_image.jpg
```
But... it is not working for me on .NEF, so I use Lat Lon EPSG:4326

```
exiftool -GPSLatitude*="48.85709456183028" -GPSLongitude*="2.3409128685467" "$Filename"
```

```
exiftool -GPSLatitude*="$GPSPosition4326Lat" -GPSLongitude*="$GPSPosition4326Lon" "$Filename"
```

## ImageMagick

Changing default parameters

in
```
/etc/ImageMagick-6/policy.xml
```
From 

```
<policymap>
  <!-- <policy domain="resource" name="temporary-path" value="/tmp"/> -->
  <policy domain="resource" name="memory" value="256MiB"/>
  <policy domain="resource" name="map" value="512MiB"/>
  <policy domain="resource" name="width" value="16KP"/>
  <policy domain="resource" name="height" value="16KP"/>
  <policy domain="resource" name="area" value="128MB"/>
  <policy domain="resource" name="disk" value="1GiB"/>
  <!-- <policy domain="resource" name="file" value="768"/> -->
  <!-- <policy domain="resource" name="thread" value="4"/> -->
  <!-- <policy domain="resource" name="throttle" value="0"/> -->
  <!-- <policy domain="resource" name="time" value="3600"/> -->
  <!-- <policy domain="system" name="precision" value="6"/> -->
  <!-- not needed due to the need to use explicitly by mvg: -->
  <!-- <policy domain="delegate" rights="none" pattern="MVG" /> -->
  <!-- use curl -->
  <policy domain="delegate" rights="none" pattern="URL" />
  <policy domain="delegate" rights="none" pattern="HTTPS" />
  <policy domain="delegate" rights="none" pattern="HTTP" />
  <!-- in order to avoid to get image with password text -->
  <policy domain="path" rights="none" pattern="@*"/>
  <policy domain="cache" name="shared-secret" value="passphrase" stealth="true"/>
  <!-- disable ghostscript format types -->
  <policy domain="coder" rights="none" pattern="PS" />
  <policy domain="coder" rights="none" pattern="PS2" />
  <policy domain="coder" rights="none" pattern="PS3" />
  <policy domain="coder" rights="none" pattern="EPS" />
  <policy domain="coder" rights="read|write" pattern="PDF" />
  <policy domain="coder" rights="none" pattern="XPS" />
</policymap>
```

To

```
  <policy domain="resource" name="memory" value="14GiB"/>
  <policy domain="resource" name="map" value="30GiB"/>
  <policy domain="resource" name="width" value="16MP"/>
  <policy domain="resource" name="height" value="16MP"/>
  <policy domain="resource" name="area" value="40GP"/>
  <policy domain="resource" name="disk" value="30GiB"/>
```



convert & resize geotiff with alpha to png with a 200px height and homothetic width

```
convert ../_Output/"$Lastrender"[1]  -define png:swap-bytes -resize x200 ../_Output_PNG_Preview/"$NameNoExt"_"$Year".png
```
convert to base64

```
convert preview.png -resize 400x400 PNG:- | base64
```


### Gdal reder GeoTiff from .tif ans .tfw

```
gdal_translate -co TFW="YES" source.tif output.geotiff
```

SVG with no background

```
convert -background none logo_black.svg -resize 40x40 PNG:- | base64
```

base64 sctructure
```
<img src="data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAUA
AAAFCAYAAACNbyblAAAAHElEQVQI12P4//8/w38GIAXDIBKE0DHxgljNBAAO
9TXL0Y4OHwAAAABJRU5ErkJggg==" alt="Red dot">
```

https://www.drupal.org/project/bundle_copy

## Process : Georeference & import
Georeference from EPSG: 27561 -> GeoTiff
```
Kta2Geo/Start_Program.sh
```
Then choose menu 2 GeoRefIGC_And_CSV
- Choose the name of the Geoserver Workspace
- Choose the hard path where the files will be stored and where apache can read.
- /var/www/MyVerySpecialPath/WokspaceName/
- the subfolder will be :
```
_Output_3857  _Output_PNG_Preview  _Output_wld_zip
```
eg. (don't forget the taling slash)
```
/var/www/MyVerySpecialPath/WokspaceName/_Output_3857/
/var/www/MyVerySpecialPath/WokspaceName/_Output_PNG_Preview/
/var/www/MyVerySpecialPath/WokspaceName/_Output_wld_zip/
```
Generating :
1 ) - List_Special_Planches.csv

1.1 ) - GeoTiff EPSG: 3857 

2 )- Zip .jpg + .wld + .prj EPSG: 3857

3 ) - Png preview convert -resize x200

3.1 ) - Wait for upload Geotif, .zip .png to the right place and hit enter

Once upload on the server is done.

4 ) - Run again
```
Kta2Geo/Start_Program.sh
```
5 ) - Choose menu 3 Update_Layers_in_server

6 ) - Validate path in server where the original geotiff, png, and zip are storred (must be readable by apache)

7 ) - With a new shell via ssh, execute command on the distant server
```
---> On the distant server list existing geottifs : /your/path/List_Geotifs_private_Raw_map.sh
```

8 ) - Once the process is done back to first shell hit enter to download the allready existing files loaded in the DB
```
---> Hit enter when done!
```

9 ) - From drupal import ``` _2IMPORT.CSV ```


Done !

### Gdal
##### export Geotiff with alpha from no data 0

```
gdalwarp -dstalpha -srcnodata 0 -co "ALPHA=YES" source.tif dest_RGBA.tif
```

##### Cut GeoTiff with a shapefile polygon 

```
gdalwarp -cutline crop.shp -crop_to_cutline -dstalpha source.tif dest.tif
```

##### Merge geotiff in RGB

```
gdal_merge.py-3.8 -init 255 -o test.tif *.tif
```
```
Def .prj EPSG:3857 / mètre / Meter
```

PROJCS["WGS_1984_Web_Mercator_Auxiliary_Sphere",GEOGCS["GCS_WGS_1984",DATUM["D_WGS_1984",SPHEROID["WGS_1984",6378137.0,298.257223563]],PRIMEM["Greenwich",0.0],UNIT["Degree",0.0174532925199433]],PROJECTION["Mercator_Auxiliary_Sphere"],PARAMETER["False_Easting",0.0],PARAMETER["False_Northing",0.0],PARAMETER["Central_Meridian",0.0],PARAMETER["Standard_Parallel_1",0.0],PARAMETER["Auxiliary_Sphere_Type",0.0],UNIT["Meter",1.0]]


## Gdal convert vector line in red into raster tif 1000px x 1000px with alpha (band 4 255)

```
gdal_rasterize -co "ALPHA=YES" -burn 255 -burn 0 -burn 0 -burn 255 -ot Byte -ts 1000 1000 -l lines lines.shp lines.tif
```

### Give the stroke a width (from lines.shp buffer_lines.shp)

```
ogr2ogr -dialect SQLite -sql "SELECT ST_Buffer(geometry,2.5) FROM lines" buffer_lines.shp lines.shp
```

### Openlayers Layer Bound
Must be ordered : left, lower, right, uper

```
var mybound = new OpenLayers.Bounds(259498.621, 6246695.025, 259627.735, 6246818.799);
```

```
var mybound = new OpenLayers.Bounds(left, lower, right, uper);
```

### Gdal convert vector buffer_lines.shp to lines.shp

```
 gdal_rasterize -burn 255 -burn 0 -burn 150 -burn 255 -ot Byte -ts 1000 1000 -r bilinear -l buffer_lines buffer_lines.shp work.tif
```

## Gdal Resize Half/Size Big GeoTiff Source

in this exemple the half size with using bc :

```
half_sizeX=$(echo "$Image_Width"/2|bc -l)
```

So :

```
TheTiffSource="The_Raster_source.tif"
TheSmallerTiffName=$(echo "$TheTiffSource"| sed 's/.tif/_smaller.tif/g' )
Image_Width=$(exiftool "$TheTiffSource"| awk '/Image Width/'| awk -F': '  '{print $2}' )
Image_Height=$(exiftool "$TheTiffSource"| awk '/Image Height/'| awk -F': '  '{print $2}' )
echo Image_Width $Image_Width Image_Height $Image_Height
half_sizeX=$(echo "$Image_Width"/2|bc -l)
half_sizeY=$(echo "$Image_Height"/2|bc -l)

gdalwarp -of GTiff -co COMPRESS=DEFLATE -ts $half_sizeX $half_sizeY -r cubic "$TheTiffSource" "$TheSmallerTiffName"
```
