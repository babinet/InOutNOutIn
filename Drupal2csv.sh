#!/bin/bash
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
#sudo apt install python-pip
#sudo pip install geomet
#Extraction from drush (drush 8)
#sudo ./drush.phar ne-export --file=AllNodes.txt
tr -d '\n' < AllNodes.txt | sed -e 's/(object) array(/\
(object) array(/g' | awk '{gsub("'\'',\ \ \ \ \ \ '\''", "|"); print}' | awk '{gsub("\",\ \ \ \ \ \ '\''", "|"); print}'> AllNodesTMP.csv
printf 'vid|uid|title|logs|status|coment|promote|sticky|vuuid|nid|type|language|created|changed|tnid|translate|uuid|revision_timestamp|revision_uid|field_type|last_comment_timestamp|last_comment_name
' > NodePoi.csv
cat "AllNodesTMP.csv" | awk -F'|' '$11 == "type'\'' => '\''poi"' | awk 'NF' >> NodePoi.csv
printf 'vid|uid|title|logs|status|coment|promote|sticky|vuuid|nid|type|language|created|changed|tnid|translate|uuid|revision_timestamp|revision_uid|field_type|last_comment_timestamp|last_comment_name
' > NodeAcces.csv
cat "AllNodesTMP.csv" | awk -F'|' '$11 == "type'\'' => '\''acces"' | awk 'NF' >> NodeAcces.csv

printf 'vid|uid|title|logs|status|coment|promote|sticky|vuuid|nid|type|language|created|changed|tnid|translate|uuid|revision_timestamp|revision_uid|field_type|last_comment_timestamp|last_comment_name
' > NodeImage.csv
cat "AllNodesTMP.csv" | awk -F'|' '$11 == "type'\'' => '\''image"' | awk 'NF' >> NodeImage.csv

printf 'vid|uid|title|logs|status|coment|promote|sticky|vuuid|nid|type|language|created|changed|tnid|translate|uuid|revision_timestamp|revision_uid|field_type|last_comment_timestamp|last_comment_name
' > NodeParcours.csv
cat "AllNodesTMP.csv" | awk -F'|' '$11 == "type'\'' => '\''ma_descente"' | awk 'NF' >> NodeParcours.csv



#./Acces.sh
./Parcours.sh
