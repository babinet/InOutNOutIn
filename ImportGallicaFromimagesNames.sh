

orange=`tput setaf 11`
bg_orange=`tput setab 178`
purple=`tput setaf 13`
Line=`tput smul`
bold=`tput bold`
black=`tput setaf 0`
red=`tput setaf 1`
green=`tput setaf 2`
yellow=`tput setaf 3`
blue=`tput setaf 4`
magenta=`tput setaf 5`
cyan=`tput setaf 6`
white=`tput setaf 15`
reset=`tput sgr0`
bg_red=`tput setab 1`
bg_green=`tput setab 2`
bg_white=`tput setab 7`
bg_blue=`tput setab 4`
lightblue=`tput setaf 45`
lightgreen=`tput setaf 46`
bleuetern=`tput setaf 45`
ilghtpurple=`tput setaf 33`
lightred=`tput setaf 161`
darkblue=`tput setaf 19`
dir=$(
cd -P -- "$(dirname -- "$0")" && pwd -P
)
cd "$dir" 2>&1 &>/dev/null
mkdir -p ../_TRASH_TEMP ../_Output

FileDate=$(echo $(date +%Y_%m_%d) | tr "/" "_")

if [ -f ../_Output/ListfromGallicatmp.txt ]
then
rm ../_Output/ListfromGallicatmp.txt
fi
if [ -f ../_Output/strippedName ]
then
rm ../_Output/strippedName
fi
if [ -f ../_Output/Auteur_complet ]
then
rm ../_Output/Auteur_complet
fi

### MENU
echo "${white} Choisir le type d'images"
menu_from_array ()
{

select type; do
# Check menu item number
if [ 1 -le "$REPLY" ] && [ "$REPLY" -le $# ];

then
echo "Running $type..."
break;
else
echo "Erreur - Choisir parmis 1-$#"
fi
done
}

# Declare the array
Menu=('Dessins techniques' 'Image en sous-sol' 'Image en surface')

# Call the subroutine to create the menu
menu_from_array "${Menu[@]}"





for tifffile in ../*.tif
do




# Create Proxi Jpg with Imagemagick
filename=$(echo $tifffile| sed 's/.tif//g' |sed 's/..\///g')
if [ -f ../_Output/"$filename".jpg ]
then
echo ../_Output/"$filename".jpg exist
else
convert $tifffile -resize 1500x ../_Output/"$filename.jpg"

fi




# TEXT Import
GallicaDocumentID=$(echo $tifffile| sed 's/.tif//g' | sed 's/..\///g' )
RefAddressgallica=$(echo $tifffile| sed 's/.tif//g' | awk -F'_' '{print $1}'| sed 's/..\///g' )
echo "https://gallica.bnf.fr/ark:/12148/$Ref_gallica"
if [ -f ../_Output/"$filename.txt" ]
then
echo "$green ../_Output/"$filename".txt exist $reset"
else
wget -O ../_Output/"$filename.txt" https://gallica.bnf.fr/services/OAIRecord?ark="$RefAddressgallica"
fi






Titre_complet=$(tr -d "\n" < ../_Output/"$filename.txt" | awk -F"<dc:title>" '{print $2}' | awk -F"<" '{print $1}'| tr -d "[]")
# Shorter Title
if [ -f ../_Output/strippedName ]
then
stripedinfo=$(cat ../_Output/strippedName)
echo "$white Text rendered before "$stripedinfo" $reset"
else
echo "${bg_red}${white}---> Le nom complet est ${orange}|$Titre_complet${reset}|"
echo "${bg_red}${white}---> Voullez-vous splitter le nom complet?${reset}"
echo "Entrer un délimiteur pour printer le \$1 avec awk"
read -p "${white}shortnameseparator : ${orange}" shortnameseparator
echo "$shortnameseparator" > ../_Output/strippedName
fi
# Shorted name condition : if separator is empty or not
if [[  -f "../_Output/strippedName" && -s "../_Output/strippedName" ]]
then
shortname=$(echo "$Titre_complet"|awk -F"$shortnameseparator" '{print $1}' |awk '{$1=$1;print}')
else
shortname=$(echo "$Titre_complet" |awk '{$1=$1;print}')
fi
# End Shorter Title

Auteur_complet=$(tr -d "\n" < ../_Output/"$filename.txt" | awk -F"<dc:creator>" '{print $2}' | awk -F"<" '{print $1}'| tr -d "[]")
Page_link=$(tr -d "\n" < ../_Output/"$filename.txt" | awk -F"<dc:identifier>" '{print $2}' | awk -F"<" '{print $1}'| tr -d "[]")
# Auteur
if [ -f ../_Output/Auteur_complet ]
then
auteurstripped=$(cat ../_Output/strippedName)
echo "$white Text rendered before "$auteurstripped" $reset"
else
echo "${bg_red}${white}---> Le nom de l'aueur Gallica ${orange}|$Titre_complet${reset}|"
echo "${bg_red}${white}---> Voullez-vous remplacer ?${reset}"
read -p "${white}shortAuteur : ${orange}" shortAuteur
echo "$shortAuteur" > ../_Output/Auteur_complet
fi
# Shorted name condition : if separator is empty or not
if [[  -f "../_Output/Auteur_complet" && -s "../_Output/Auteur_complet" ]]
then
shortAuteurtxt=$(echo "$shortAuteur" |awk '{$1=$1;print}'| awk 'NF')
else
shortAuteurtxt=$(echo "$Auteur_complet" | awk 'NF' )
fi
# End Shorter Title
GUID=$(echo "$filename")

AddressGallica=$(tr -d "\n" < ../_Output/"$filename.txt" | awk -F"<dc:identifier>" '{print $2}' | awk -F"<" '{print $1}')
AnneeIssue=$(tr -d "\n" < ../_Output/"$filename.txt" | awk -F'<dc:date>' '{print $2}' | awk -F"<" '{print $1}'|sed 's/19..//g')
echo $AnneeIssue
echo $GallicaDocumentID
Format=$(tr -d "\n" < ../_Output/"$filename.txt" | awk -F"<dc:format>" '{print $2}' | awk -F"<" '{print $1}')

GallicaButton=$(echo "<a href=\"$Page_link\" data-toggle=\"tooltip\" data-placement=\"top\" data-original-title=\"Page&nbsp;Gallica&nbsp;BNF\" class=\"btn-dark&nbsp;btn-xs\"><span  class=\"gallica\"></span>IIIF Source Gallica</a>")
#Node_title|GUID|image_proxiedUri|Type_dimage
bodyinfo=$(echo "<div class=\"info-gallica\"><div class=\"Auteur_complet\">"$Auteur_complet"</div>"$GallicaButton"<div class=\"Format\">"$Format"</div></div>")

echo "${orange} "$shortname"|"$GUID"|/private_file/Image_Gallery/"$filename".jpg|"$type"|/private_file/Raw_files/"$filename".tif|"$shortAuteurtxt"|"$AnneeIssue"|"$bodyinfo"|"$Titre_complet"|"$Auteur_complet"|Chambre en bois 22,2 x 18,8 cm"
echo ""$shortname"|"$GUID"|/private_file/Image_Gallery/"$filename".jpg|"$type"|/private_file/Raw_files/"$filename".tif|"$shortAuteurtxt"|"$AnneeIssue"|"$bodyinfo"|"$Titre_complet"|"$Auteur_complet"|Chambre en bois 22,2 x 18,8 cm@Négatif / verre au collodion humide" >> ../_Output/ListfromGallicatmp.txt

#TEST|btv1b105397428|/private_file/Image_Gallery/btv1b105397428_f1.jpg|Image en sous-sol
#echo "$Titre_complet"
#echo "$Format"



done
echo "Node_title|GUID|image_proxiedUri|Type_dimage|RawImage|Auteur|Year|bodyinfo|img_title|alt_auteur|SupportFormat" > ../_Output/2import_from_gallica.csv
cat ../_Output/ListfromGallicatmp.txt >> ../_Output/2import_from_gallica.csv

# https://gallica.bnf.fr/services/OAIRecord?ark=bpt6k5738219s

#Image Native https://gallica.bnf.fr/iiif//ark:/12148/btv1b531745663_f1/f1/full/full/0/native.tif
