
for geotif in *.tif
do


exiftool -artist="sous-paris.com" -Software="kta2geo" -keywords= -m -keywords+="Source BHVP : https://bibliotheques-specialisees.paris.fr" "$geotif"

if [ -f "$geotif"_original ]
then
rm "$geotif"_original
fi
done
