




if [ -f ListfromGallicatmp.txt ]
then
rm ListfromGallicatmp.txt
fi

for tifffile in *.tif
do
filename=$(echo $tifffile| sed 's/.tif//g')
if [ -f $filename.jpg ]
then
echo "$filename".jpg exist
else
convert $tifffile -resize 1500x $filename.jpg
fi
Ref_gallica=$(echo $tifffile| sed 's/.tif//g' | awk -F'_' '{print $1}')
echo "https://gallica.bnf.fr/ark:/12148/$Ref_gallica"
#wget -O $filename.txt "https://gallica.bnf.fr/services/OAIRecord?ark=$Ref_gallica"

Titre_complet=$(tr -d "\n" < $filename.txt | awk -F"<dc:title>" '{print $2}' | awk -F"<" '{print $1}'| tr -d "[]")
GUID=$(echo "$filename")

AddressGallica=$(tr -d "\n" < $filename.txt | awk -F"<dc:identifier>" '{print $2}' | awk -F"<" '{print $1}')
AnneeIssue=$(tr -d "\n" < $filename.txt | awk -F'<dc:date>' '{print $2}' | awk -F"<" '{print $1}'|sed 's/19..//g')
echo $AnneeIssue

echo "$Titre_complet"
GallicaButton=$(echo "<a href=\"$AddressGallica\" class=\"btn btn-dark btn-xs\">Source Gallica</a>")
#Node_title|GUID|image_proxiedUri|Type_dimage

echo ""$Titre_complet"|"$Ref_gallica"|/private_file/Image_Gallery/"$filename".jpg|Image en sous-sol|/private_file/Raw_files/"$filename".tif" >> ListfromGallicatmp.txt

#TEST|btv1b105397428|/private_file/Image_Gallery/btv1b105397428_f1.jpg|Image en sous-sol
done
echo "Node_title|GUID|image_proxiedUri|Type_dimage|RawImage" > 2import_from_gallica.csv
cat ListfromGallicatmp.txt >> 2import_from_gallica.csv

# https://gallica.bnf.fr/services/OAIRecord?ark=bpt6k5738219s

#Image Native https://gallica.bnf.fr/iiif//ark:/12148/btv1b10539711k/f1/full/full/0/native.tif
