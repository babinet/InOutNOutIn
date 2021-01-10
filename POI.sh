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
FileDate=$(echo $(date +%Y_%m_%d) | tr "/" "_")

while read -re linecsv
do
# NODE INFO + DATA
substringfields=$(echo "$linecsv" | awk -F'|' '{print $20}' )
#echo "$red$substringfields"
NodeTitle=$(echo -e "$linecsv" | awk -F'|' '{print $3}' | sed "s/title' => //g" | sed 's/^"//g' | sed "s/^'//g" | awk 'FNR == 1' | sed 's/&/et/g' | sed 's/->/→/g' | sed 's/<-/←/g' | sed 's/>/→/g' | sed 's/</←/g' )
#↓ ↑ ← →


echo -e "${white}---> \$NodeTitle               ----- ------ ------ ------ ------> ${orange}$NodeTitle"
NodeID=$(echo -e "$linecsv" | awk -F'nid'\'' => '\''' '{print $2}' | awk -F'|' '{print $1}' | awk 'NF')
echo -e "${white}---> \$NodeID                  ----- ------ ------ ------ ------> ${orange}"$NodeID""
NodeVID=$(echo -e "$linecsv" | awk -F'vid'\'' => '\''' '{print $2}' | awk -F'|' '{print $1}' | awk 'NF')
echo -e "${white}---> \$NodeVID                 ----- ------ ------ ------ ------> ${orange}"$NodeVID""
Vuuid=$(echo -e "$linecsv" | awk -F'vuuid'\'' => '\''' '{print $2}' | awk -F'|' '{print $1}' | awk 'NF')
echo -e "${white}---> \$Vuuid                   ----- ------ ------ ------ ------> ${orange}"$Vuuid""

Date=$(echo -e "$linecsv" | awk -F'created'\'' => '\''' '{print $2}' | awk -F'|' '{print $1}' | awk 'NF')
echo -e "${white}---> \$Date                    ----- ------ ------ ------ ------> ${orange}"$Date""
RevisionTimestamp=$(echo -e "$linecsv" | awk -F'changed'\'' => '\''' '{print $2}' | awk -F'|' '{print $1}' | awk 'NF')
echo -e "${white}---> \$RevisionTimestamp       ----- ------ ------ ------ ------> ${orange}"$RevisionTimestamp""

# F#cking Date on Mac OS X Darwin (Condition)
System=$(uname)
if [ "$System" == "Darwin" ]
then
echo "Date MAC OS X condition"
CreatedDatetmp=$(date -r $Date | sed 's/CET //g'| sed 's/UTC //g' | sed 's/CEST //g')
# KML DATE FORMAT
CreatedDate=$(date -jf"%a %b %e %H:%M:%S %Y" "$CreatedDatetmp" +"%Y-%m-%dT%H:%M:%S+01:00")
LastRevisionTimestamptmp=$(date -r $RevisionTimestamp | sed 's/CET //g'| sed 's/UTC //g' | sed 's/CEST //g')
# KML DATE FORMAT Last revision
LastRevisionTimestamp=$(date -jf"%a %b %e %H:%M:%S %Y" "$LastRevisionTimestamptmp" +"%Y-%m-%dT%H:%M:%S+01:00")
else
CreatedDatetmp=$(date -d @$Date | sed 's/CET //g'| sed 's/UTC //g' | sed 's/CEST //g')
# KML DATE FORMAT
CreatedDate=$(date -d "$CreatedDatetmp" +"%Y-%m-%dT%H:%M:%S+01:00")
LastRevisionTimestamptmp=$(date -d @$RevisionTimestamp | sed 's/CET //g'| sed 's/UTC //g' | sed 's/CEST //g')
# KML DATE FORMAT
LastRevisionTimestamp=$(date -d "$LastRevisionTimestamptmp" +"%Y-%m-%dT%H:%M:%S+01:00")
fi

echo -e "${white}---> \$CreatedDate             ----- ------ ------ ------ ------> ${orange}"$CreatedDate""
echo -e "${white}---> \$LastRevisionTimestamp   ----- ------ ------ ------ ------> ${orange}"$LastRevisionTimestamp""
substringfieldsGeom=$(echo "$linecsv" | awk -F'|' '{print $20}' | awk -F''\''geometry'\'' => '\''' '{print $2}' | awk -F''\''' '{print $1}' | awk 'NF' | geomet )
#
SRSID=$(echo -e "$substringfieldsGeom" | awk -F'\"name\": \"EPSG' '{print $2}' | awk -F''\"'' '{print $1}')
coordinates3857=$(echo -e "$substringfieldsGeom" | awk -F'coordinates\": ' '{print $2}' | awk -F', \"' '{print $1}' | tr -d '[]' )
echo -e "${white}---> \$coordinates3857         ----- ------ ------ ------ ------> ${orange}"$coordinates3857""
TypeGeom=$(echo -e "$substringfieldsGeom" | awk -F'"srid": ' '{print $2}' | awk -F'\"type\": \"' '{print $2}' | awk -F'\"' '{print $1}')
#echo -e "${white}---> \$TypeGeom                ----- ------ ------ ------ ------> ${orange}"$TypeGeom""
TypeDePOI=$(echo -e "$substringfields" | awk -F'field_type_poi' '{print $2}' | awk -F'tid'\'' => '\''' '{print $2}'| awk -F''\''' '{print $1}' |awk 'NF')
echo -e "${white}---> \$TypeDePOI              ----- ------ ------ ------ ------> ${orange}"$TypeDePOI""
#'field_type_de_consolidation' => array(        'und' => array(          array(            'tid' => '183'
TypeDInscription=$(echo -e "$linecsv" | awk -F'field_type_de_consolidation' '{print $2}' |  awk -F'tid'\'' => '\'''  '{print $2}' | awk -F''\'',' '{print $1}' |awk 'NF' | awk '{print $1}')
echo -e "${white}---> \$TypeDInscription                 ----- ------ ------ ------ ------> ${purple}"$TypeDInscription""
#OpenClosed=$(echo -e "$substringfields" | awk -F'field_etat_acces' '{print $2}' |  awk -F'tid'\'' => '\'''  '{print $2}' | awk -F''\'',' '{print $1}' |awk 'NF')
InspecteurName=$()
echo -e "${white}---> \$OpenClosed              ----- ------ ------ ------ ------> ${orange}"$OpenClosed""
coordinates4326=$(echo "$coordinates3857"| gdaltransform -s_srs EPSG:3857 -t_srs EPSG:4326 | sed 's/\ /\,/g')
echo -e "${white}---> \$coordinates4326         ----- ------ ------ ------ ------> ${orange}"$coordinates4326""
body=$(printf "$substringfields" | tr -d '\n'| awk -F'body' '{print $2}' |  awk -F'value'\'' => "'  '{print $2}' | awk -F'",            '\''summary'\'' =>' '{print $1}' | sed 's/<p/\
<p/'g  | sed 's/<\/p/\
<\/p/'g | sed 's/<span/\
<span/'g  | sed 's/<\/span/\
<\/span/'g| sed 's/<div/\
<div/'g| sed 's/<br/\
<br/'g| sed 's/<\/div/\
<\/div/'g | sed 's/>/>\
/'g | sed 's/&nbsp;//g' | awk '!/<span/' | awk '!/<\/span/' | awk '!/<p/'| awk '!/<\/p/'| awk '!/<\/div/'| awk '!/<div/' | awk 'NF'|awk '!/^[[:blank:]]*$/')
echo -e "---> \$body  ------ ------ ------ ------ ------> "$body""

if [[ "$TypeDePOI" == 311 ]]
then
TypeDePOIsABC=$(echo -e "Lieu dit")
IconAPOI=$(echo "https://raw.githubusercontent.com/babinet/InOutNOutIn/main/SVG/LD.svg")
echo -e "${white}---> Type de P.O.I : ${orange}Lieu dit"
StyleKml="LD"
fi
if [[ "$TypeDePOI" == 310 ]]
then
TypeDePOIsABC=$(echo -e "Puits à eau")
IconAPOI=$(echo "https://raw.githubusercontent.com/babinet/InOutNOutIn/main/SVG/PE.svg")
StyleKml="PE"
echo -e "${white}---> Type de P.O.I : ${orange}Puits à eau"
fi
if [[ "$TypeDePOI" == 305 ]]
then
TypeDePOIsABC=$(echo -e "Abri")
IconAPOI=$(echo "https://raw.githubusercontent.com/babinet/InOutNOutIn/main/SVG/A.svg")
StyleKml="A"
echo -e "${white}---> Type de P.O.I : ${orange}Abri"
fi
if [[ "$TypeDePOI" == 306 ]]
then
TypeDePOIsABC=$(echo -e "Curiosité")
IconAPOI=$(echo "https://raw.githubusercontent.com/babinet/InOutNOutIn/main/SVG/CRs.svg")
StyleKml="CRs"
echo -e "${white}---> Type de P.O.I : ${orange}Curiosité"
fi
if [[ "$TypeDePOI" == 302 ]]
then
TypeDePOIsABC=$(echo -e "Inscription premier niveau")
IconAPOI=$(echo "https://raw.githubusercontent.com/babinet/InOutNOutIn/main/SVG/ISc1.svg")
StyleKml="ISc1"
echo -e "${white}---> Type de P.O.I : ${orange}Inscription premier niveau"
fi
if [[ "$TypeDePOI" == 303 ]]
then
TypeDePOIsABC=$(echo -e "Inscription deuxième niveau")
IconAPOI=$(echo "https://raw.githubusercontent.com/babinet/InOutNOutIn/main/SVG/ISc2.svg")
StyleKml="ISc2"
echo -e "${white}---> Type de P.O.I : ${orange}Inscription deuxième niveau"
fi
if [[ "$TypeDePOI" == 304 ]]
then
TypeDePOIsABC=$(echo -e "Inscription troisième niveau")
IconAPOI=$(echo "https://raw.githubusercontent.com/babinet/InOutNOutIn/main/SVG/ISc3.svg")
StyleKml="ISc3"
echo -e "${white}---> Type de P.O.I : ${orange}Inscription troisième niveau"
fi


# Inspecteurs / Architectes
if [[ "$InspecteurName" == 139 ]]; then Achitecte=$(echo -e "François Mansart"); echo -e "${white}---> Inspecteurs / Architectes : ${orange}$Achitecte"; fi
if [[ "$InspecteurName" == 312 ]]; then Achitecte=$(echo -e "Antoine Dupont"); echo -e "${white}---> Inspecteurs / Architectes : ${orange}$Achitecte"; fi
if [[ "$InspecteurName" == 92 ]]; then Achitecte=$(echo -e "Charles-Axel Guillaumot"); echo -e "${white}---> Inspecteurs / Architectes : ${orange}$Achitecte"; fi
if [[ "$InspecteurName" == 96 ]]; then Achitecte=$(echo -e "Duchemin"); echo -e "${white}---> Inspecteurs / Architectes : ${orange}$Achitecte"; fi
if [[ "$InspecteurName" == 98 ]]; then Achitecte=$(echo -e "Demoustier"); echo -e "${white}---> Inspecteurs / Architectes : ${orange}$Achitecte"; fi
if [[ "$InspecteurName" == 99 ]]; then Achitecte=$(echo -e "Bralle"); echo -e "${white}---> Inspecteurs / Architectes : ${orange}$Achitecte"; fi
if [[ "$InspecteurName" == 103 ]]; then Achitecte=$(echo -e "Commission"); echo -e "${white}---> Inspecteurs / Architectes : ${orange}$Achitecte"; fi
if [[ "$InspecteurName" == 93 ]]; then Achitecte=$(echo -e "Héricart de Thury"); echo -e "${white}---> Inspecteurs / Architectes : ${orange}$Achitecte"; fi
if [[ "$InspecteurName" == 105 ]]; then Achitecte=$(echo -e "Trémery"); echo -e "${white}---> Inspecteurs / Architectes : ${orange}$Achitecte"; fi
if [[ "$InspecteurName" == 107 ]]; then Achitecte=$(echo -e "Juncker"); echo -e "${white}---> Inspecteurs / Architectes : ${orange}$Achitecte"; fi
if [[ "$InspecteurName" == 110 ]]; then Achitecte=$(echo -e "Lorieux"); echo -e "${white}---> Inspecteurs / Architectes : ${orange}$Achitecte"; fi
if [[ "$InspecteurName" == 102 ]]; then Achitecte=$(echo -e "Blavier"); echo -e "${white}---> Inspecteurs / Architectes : ${orange}$Achitecte"; fi
if [[ "$InspecteurName" == 112 ]]; then Achitecte=$(echo -e "De Hennezel"); echo -e "${white}---> Inspecteurs / Architectes : ${orange}$Achitecte"; fi
if [[ "$InspecteurName" == 115 ]]; then Achitecte=$(echo -e "Du Souich"); echo -e "${white}---> Inspecteurs / Architectes : ${orange}$Achitecte"; fi
if [[ "$InspecteurName" == 117 ]]; then Achitecte=$(echo -e "De Fourcy"); echo -e "${white}---> Inspecteurs / Architectes : ${orange}$Achitecte"; fi
if [[ "$InspecteurName" == 118 ]]; then Achitecte=$(echo -e "Lantillon"); echo -e "${white}---> Inspecteurs / Architectes : ${orange}$Achitecte"; fi
if [[ "$InspecteurName" == 119 ]]; then Achitecte=$(echo -e "Jacquot"); echo -e "${white}---> Inspecteurs / Architectes : ${orange}$Achitecte"; fi
if [[ "$InspecteurName" == 123 ]]; then Achitecte=$(echo -e "Tournaire"); echo -e "${white}---> Inspecteurs / Architectes : ${orange}$Achitecte"; fi
if [[ "$InspecteurName" == 129 ]]; then Achitecte=$(echo -e "Roger"); echo -e "${white}---> Inspecteurs / Architectes : ${orange}$Achitecte"; fi
if [[ "$InspecteurName" == 120 ]]; then Achitecte=$(echo -e "Descottes"); echo -e "${white}---> Inspecteurs / Architectes : ${orange}$Achitecte"; fi
if [[ "$InspecteurName" == 126 ]]; then Achitecte=$(echo -e "Gentil"); echo -e "${white}---> Inspecteurs / Architectes : ${orange}$Achitecte"; fi
if [[ "$InspecteurName" == 131 ]]; then Achitecte=$(echo -e "O. KELLER"); echo -e "${white}---> Inspecteurs / Architectes : ${orange}$Achitecte"; fi
if [[ "$InspecteurName" == 134 ]]; then Achitecte=$(echo -e "Wickersheimer"); echo -e "${white}---> Inspecteurs / Architectes : ${orange}$Achitecte"; fi
if [[ "$InspecteurName" == 135 ]]; then Achitecte=$(echo -e "Weiss"); echo -e "${white}---> Inspecteurs / Architectes : ${orange}$Achitecte"; fi


# Année (to be updated)
if [[ "$InscriptionYear" == 140 ]]; then Annee=$(echo -e "1624"); echo -e "${white}---> Année : ${orange}$Annee"; fi
if [[ "$InscriptionYear" == 392 ]]; then Annee=$(echo -e "1709"); echo -e "${white}---> Année : ${orange}$Annee"; fi
if [[ "$InscriptionYear" == 171 ]]; then Annee=$(echo -e "1777"); echo -e "${white}---> Année : ${orange}$Annee"; fi
if [[ "$InscriptionYear" == 156 ]]; then Annee=$(echo -e "1778"); echo -e "${white}---> Année : ${orange}$Annee"; fi
if [[ "$InscriptionYear" == 141 ]]; then Annee=$(echo -e "1780"); echo -e "${white}---> Année : ${orange}$Annee"; fi
if [[ "$InscriptionYear" == 173 ]]; then Annee=$(echo -e "1781"); echo -e "${white}---> Année : ${orange}$Annee"; fi
if [[ "$InscriptionYear" == 293 ]]; then Annee=$(echo -e "1784"); echo -e "${white}---> Année : ${orange}$Annee"; fi
if [[ "$InscriptionYear" == 177 ]]; then Annee=$(echo -e "1785"); echo -e "${white}---> Année : ${orange}$Annee"; fi
if [[ "$InscriptionYear" == 89 ]]; then Annee=$(echo -e "1786"); echo -e "${white}---> Année : ${orange}$Annee"; fi
if [[ "$InscriptionYear" == 91 ]]; then Annee=$(echo -e "1791"); echo -e "${white}---> Année : ${orange}$Annee"; fi
if [[ "$InscriptionYear" == 144 ]]; then Annee=$(echo -e "1792"); echo -e "${white}---> Année : ${orange}$Annee"; fi
if [[ "$InscriptionYear" == 383 ]]; then Annee=$(echo -e "1797"); echo -e "${white}---> Année : ${orange}$Annee"; fi
if [[ "$InscriptionYear" == 149 ]]; then Annee=$(echo -e "1802"); echo -e "${white}---> Année : ${orange}$Annee"; fi
if [[ "$InscriptionYear" == 151 ]]; then Annee=$(echo -e "1804"); echo -e "${white}---> Année : ${orange}$Annee"; fi
if [[ "$InscriptionYear" == 388 ]]; then Annee=$(echo -e "1805"); echo -e "${white}---> Année : ${orange}$Annee"; fi
if [[ "$InscriptionYear" == 137 ]]; then Annee=$(echo -e "1806"); echo -e "${white}---> Année : ${orange}$Annee"; fi
if [[ "$InscriptionYear" == 104 ]]; then Annee=$(echo -e "1808"); echo -e "${white}---> Année : ${orange}$Annee"; fi
if [[ "$InscriptionYear" == 150 ]]; then Annee=$(echo -e "1809"); echo -e "${white}---> Année : ${orange}$Annee"; fi
if [[ "$InscriptionYear" == 387 ]]; then Annee=$(echo -e "1810"); echo -e "${white}---> Année : ${orange}$Annee"; fi
if [[ "$InscriptionYear" == 148 ]]; then Annee=$(echo -e "1811"); echo -e "${white}---> Année : ${orange}$Annee"; fi
if [[ "$InscriptionYear" == 94 ]]; then Annee=$(echo -e "1817"); echo -e "${white}---> Année : ${orange}$Annee"; fi
if [[ "$InscriptionYear" == 389 ]]; then Annee=$(echo -e "1819"); echo -e "${white}---> Année : ${orange}$Annee"; fi
if [[ "$InscriptionYear" == 172 ]]; then Annee=$(echo -e "1822"); echo -e "${white}---> Année : ${orange}$Annee"; fi
if [[ "$InscriptionYear" == 385 ]]; then Annee=$(echo -e "1825"); echo -e "${white}---> Année : ${orange}$Annee"; fi
if [[ "$InscriptionYear" == 382 ]]; then Annee=$(echo -e "1835"); echo -e "${white}---> Année : ${orange}$Annee"; fi
if [[ "$InscriptionYear" == 106 ]]; then Annee=$(echo -e "1841"); echo -e "${white}---> Année : ${orange}$Annee"; fi
if [[ "$InscriptionYear" == 375 ]]; then Annee=$(echo -e "1842"); echo -e "${white}---> Année : ${orange}$Annee"; fi
if [[ "$InscriptionYear" == 376 ]]; then Annee=$(echo -e "1843"); echo -e "${white}---> Année : ${orange}$Annee"; fi
if [[ "$InscriptionYear" == 109 ]]; then Annee=$(echo -e "1844"); echo -e "${white}---> Année : ${orange}$Annee"; fi
if [[ "$InscriptionYear" == 291 ]]; then Annee=$(echo -e "1845"); echo -e "${white}---> Année : ${orange}$Annee"; fi
if [[ "$InscriptionYear" == 194 ]]; then Annee=$(echo -e "1846"); echo -e "${white}---> Année : ${orange}$Annee"; fi
if [[ "$InscriptionYear" == 290 ]]; then Annee=$(echo -e "1847"); echo -e "${white}---> Année : ${orange}$Annee"; fi
if [[ "$InscriptionYear" == 371 ]]; then Annee=$(echo -e "1848"); echo -e "${white}---> Année : ${orange}$Annee"; fi
if [[ "$InscriptionYear" == 372 ]]; then Annee=$(echo -e "1849"); echo -e "${white}---> Année : ${orange}$Annee"; fi
if [[ "$InscriptionYear" == 166 ]]; then Annee=$(echo -e "1850"); echo -e "${white}---> Année : ${orange}$Annee"; fi
if [[ "$InscriptionYear" == 165 ]]; then Annee=$(echo -e "1851"); echo -e "${white}---> Année : ${orange}$Annee"; fi
if [[ "$InscriptionYear" == 175 ]]; then Annee=$(echo -e "1852"); echo -e "${white}---> Année : ${orange}$Annee"; fi
if [[ "$InscriptionYear" == 374 ]]; then Annee=$(echo -e "1852"); echo -e "${white}---> Année : ${orange}$Annee"; fi
if [[ "$InscriptionYear" == 111 ]]; then Annee=$(echo -e "1853"); echo -e "${white}---> Année : ${orange}$Annee"; fi
if [[ "$InscriptionYear" == 195 ]]; then Annee=$(echo -e "1854"); echo -e "${white}---> Année : ${orange}$Annee"; fi
if [[ "$InscriptionYear" == 187 ]]; then Annee=$(echo -e "1855"); echo -e "${white}---> Année : ${orange}$Annee"; fi
if [[ "$InscriptionYear" == 101 ]]; then Annee=$(echo -e "1856"); echo -e "${white}---> Année : ${orange}$Annee"; fi
if [[ "$InscriptionYear" == 196 ]]; then Annee=$(echo -e "1857"); echo -e "${white}---> Année : ${orange}$Annee"; fi
if [[ "$InscriptionYear" == 198 ]]; then Annee=$(echo -e "1858"); echo -e "${white}---> Année : ${orange}$Annee"; fi
if [[ "$InscriptionYear" == 201 ]]; then Annee=$(echo -e "1859"); echo -e "${white}---> Année : ${orange}$Annee"; fi
if [[ "$InscriptionYear" == 199 ]]; then Annee=$(echo -e "186 ?"); echo -e "${white}---> Année : ${orange}$Annee"; fi
if [[ "$InscriptionYear" == 163 ]]; then Annee=$(echo -e "1861"); echo -e "${white}---> Année : ${orange}$Annee"; fi
if [[ "$InscriptionYear" == 200 ]]; then Annee=$(echo -e "1862"); echo -e "${white}---> Année : ${orange}$Annee"; fi
if [[ "$InscriptionYear" == 114 ]]; then Annee=$(echo -e "1863"); echo -e "${white}---> Année : ${orange}$Annee"; fi
if [[ "$InscriptionYear" == 161 ]]; then Annee=$(echo -e "1864"); echo -e "${white}---> Année : ${orange}$Annee"; fi
if [[ "$InscriptionYear" == 116 ]]; then Annee=$(echo -e "1865"); echo -e "${white}---> Année : ${orange}$Annee"; fi
if [[ "$InscriptionYear" == 349 ]]; then Annee=$(echo -e "1866"); echo -e "${white}---> Année : ${orange}$Annee"; fi
if [[ "$InscriptionYear" == 197 ]]; then Annee=$(echo -e "1867"); echo -e "${white}---> Année : ${orange}$Annee"; fi
if [[ "$InscriptionYear" == 186 ]]; then Annee=$(echo -e "1868"); echo -e "${white}---> Année : ${orange}$Annee"; fi
if [[ "$InscriptionYear" == 185 ]]; then Annee=$(echo -e "1869"); echo -e "${white}---> Année : ${orange}$Annee"; fi
if [[ "$InscriptionYear" == 191 ]]; then Annee=$(echo -e "187"); echo -e "${white}---> Année : ${orange}$Annee"; fi
if [[ "$InscriptionYear" == 370 ]]; then Annee=$(echo -e "187?"); echo -e "${white}---> Année : ${orange}$Annee"; fi
if [[ "$InscriptionYear" == 182 ]]; then Annee=$(echo -e "1870"); echo -e "${white}---> Année : ${orange}$Annee"; fi
if [[ "$InscriptionYear" == 190 ]]; then Annee=$(echo -e "1871"); echo -e "${white}---> Année : ${orange}$Annee"; fi
if [[ "$InscriptionYear" == 189 ]]; then Annee=$(echo -e "1872"); echo -e "${white}---> Année : ${orange}$Annee"; fi
if [[ "$InscriptionYear" == 188 ]]; then Annee=$(echo -e "1873"); echo -e "${white}---> Année : ${orange}$Annee"; fi
if [[ "$InscriptionYear" == 121 ]]; then Annee=$(echo -e "1875"); echo -e "${white}---> Année : ${orange}$Annee"; fi
if [[ "$InscriptionYear" == 124 ]]; then Annee=$(echo -e "1876"); echo -e "${white}---> Année : ${orange}$Annee"; fi
if [[ "$InscriptionYear" == 174 ]]; then Annee=$(echo -e "1877"); echo -e "${white}---> Année : ${orange}$Annee"; fi
if [[ "$InscriptionYear" == 127 ]]; then Annee=$(echo -e "1878"); echo -e "${white}---> Année : ${orange}$Annee"; fi
if [[ "$InscriptionYear" == 152 ]]; then Annee=$(echo -e "1882"); echo -e "${white}---> Année : ${orange}$Annee"; fi
if [[ "$InscriptionYear" == 130 ]]; then Annee=$(echo -e "1883"); echo -e "${white}---> Année : ${orange}$Annee"; fi
if [[ "$InscriptionYear" == 192 ]]; then Annee=$(echo -e "1884"); echo -e "${white}---> Année : ${orange}$Annee"; fi
if [[ "$InscriptionYear" == 168 ]]; then Annee=$(echo -e "1885"); echo -e "${white}---> Année : ${orange}$Annee"; fi
if [[ "$InscriptionYear" == 170 ]]; then Annee=$(echo -e "1889"); echo -e "${white}---> Année : ${orange}$Annee"; fi
if [[ "$InscriptionYear" == 143 ]]; then Annee=$(echo -e "1890"); echo -e "${white}---> Année : ${orange}$Annee"; fi
if [[ "$InscriptionYear" == 283 ]]; then Annee=$(echo -e "1891"); echo -e "${white}---> Année : ${orange}$Annee"; fi
if [[ "$InscriptionYear" == 284 ]]; then Annee=$(echo -e "1892"); echo -e "${white}---> Année : ${orange}$Annee"; fi
if [[ "$InscriptionYear" == 167 ]]; then Annee=$(echo -e "1893"); echo -e "${white}---> Année : ${orange}$Annee"; fi
if [[ "$InscriptionYear" == 132 ]]; then Annee=$(echo -e "1895"); echo -e "${white}---> Année : ${orange}$Annee"; fi
if [[ "$InscriptionYear" == 169 ]]; then Annee=$(echo -e "1896"); echo -e "${white}---> Année : ${orange}$Annee"; fi
if [[ "$InscriptionYear" == 285 ]]; then Annee=$(echo -e "1897"); echo -e "${white}---> Année : ${orange}$Annee"; fi
if [[ "$InscriptionYear" == 384 ]]; then Annee=$(echo -e "1901"); echo -e "${white}---> Année : ${orange}$Annee"; fi
if [[ "$InscriptionYear" == 390 ]]; then Annee=$(echo -e "1908"); echo -e "${white}---> Année : ${orange}$Annee"; fi
if [[ "$InscriptionYear" == 391 ]]; then Annee=$(echo -e "1909"); echo -e "${white}---> Année : ${orange}$Annee"; fi
if [[ "$InscriptionYear" == 386 ]]; then Annee=$(echo -e "1939"); echo -e "${white}---> Année : ${orange}$Annee"; fi
if [[ "$InscriptionYear" == 145 ]]; then Annee=$(echo -e "1993"); echo -e "${white}---> Année : ${orange}$Annee"; fi
if [[ "$InscriptionYear" == 278 ]]; then Annee=$(echo -e "2011"); echo -e "${white}---> Année : ${orange}$Annee"; fi

## Type D'inscriptions
if [[ "$TypeDInscription" == 183 ]]; then TypeDInscriptionABC=$(echo -e "Consolidation"); echo -e "${white}---> Type D'inscriptions : ${orange}$TypeDInscriptionABC"; fi
if [[ "$TypeDInscription" == 322 ]]; then TypeDInscriptionABC=$(echo -e "Metropolitain"); echo -e "${white}---> Type D'inscriptions : ${orange}$TypeDInscriptionABC"; fi
if [[ "$TypeDInscription" == 364 ]]; then TypeDInscriptionABC=$(echo -e "Dessin"); echo -e "${white}---> Type D'inscriptions : ${orange}$TypeDInscriptionABC"; fi
if [[ "$TypeDInscription" == 366 ]]; then TypeDInscriptionABC=$(echo -e "Épure"); echo -e "${white}---> Type D'inscriptions : ${orange}$TypeDInscriptionABC"; fi
if [[ "$TypeDInscription" == 327 ]]; then TypeDInscriptionABC=$(echo -e "Fusain"); echo -e "${white}---> Type D'inscriptions : ${orange}$TypeDInscriptionABC"; fi
if [[ "$TypeDInscription" == 180 ]]; then TypeDInscriptionABC=$(echo -e "Indication altimétrique"); echo -e "${white}---> Type D'inscriptions : ${orange}$TypeDInscriptionABC"; fi
if [[ "$TypeDInscription" == 365 ]]; then TypeDInscriptionABC=$(echo -e "Indications topographique"); echo -e "${white}---> Type D'inscriptions : ${orange}$TypeDInscriptionABC"; fi
if [[ "$TypeDInscription" == 275 ]]; then TypeDInscriptionABC=$(echo -e "Nom de lieu"); echo -e "${white}---> Type D'inscriptions : ${orange}$TypeDInscriptionABC"; fi
if [[ "$TypeDInscription" == 326 ]]; then TypeDInscriptionABC=$(echo -e "Sanguine"); echo -e "${white}---> Type D'inscriptions : ${orange}$TypeDInscriptionABC"; fi
if [[ "$TypeDInscription" == 330 ]]; then TypeDInscriptionABC=$(echo -e "Voie"); echo -e "${white}---> Type D'inscriptions : ${orange}$TypeDInscriptionABC"; fi

echo -e "     <Placemark>
        <name>"$NodeTitle"</name>
        <TimeStamp><when>"$CreatedDate"</when></TimeStamp>
        <styleUrl>#$StyleKml</styleUrl>
        <ExtendedData>
          <SchemaData schemaUrl=\"#schemPOI\">
            <SimpleData name=\"Type de P.O.I\">"$TypeDePOIsABC"</SimpleData>
            <SimpleData name=\"Type d’inscription\">"$TypeDInscription"</SimpleData>
            <SimpleData name=\"Inspecteur / Architecte\">"$Achitecte"</SimpleData>
            <SimpleData name=\"Description\">"$body"</SimpleData>
            <SimpleData name=\"NodeID\">"$Annee"</SimpleData>
            <SimpleData name=\"Commentaire\"></SimpleData>
            <SimpleData name=\"Date de Création\"><when>"$CreatedDate"</when></SimpleData>
            <SimpleData name=\"NodeID\">"$NodeID"</SimpleData>
            <SimpleData name=\"VID\">"$NodeVID"</SimpleData>
            <SimpleData name=\"Vuuid\">"$Vuuid"</SimpleData>
          </SchemaData>
        </ExtendedData>
        <Point>
        <coordinates>$coordinates4326</coordinates>
        </Point>
      </Placemark>" >> POITemp.kml
done < NodePoi.csv

echo -e '<?xml version="1.0" encoding="UTF-8"?>
<kml xmlns="http://www.opengis.net/kml/2.2" xmlns:gx="http://www.google.com/kml/ext/2.2">
  <Document>
    <Schema id="schemPOI" name="schema POI">
      <SimpleField name="Description" type="string"/>
      <SimpleField name="pdfmaps_photos" type="string">
        <displayName>Photos</displayName>
      </SimpleField>
      <SimpleField name="Année" type="string"/>
      <SimpleField name="Inspecteur / Architecte" type="string"/>
      <SimpleField name="Type De P.OI" type="string"/>
      <SimpleField name="Type D’inscription" type="string"/>
      <SimpleField name="Voie, lieu dit" type="string"/>
    </Schema>
    <ExtendedData xmlns:avenza="http://www.avenza.com">
          <avenza:picklist schemaUrl="schemPOI" avenza:field="Type De P.OI">
          <avenza:picklistvalue><![CDATA[Abri]]></avenza:picklistvalue>
          <avenza:picklistvalue><![CDATA[Lieu dit]]></avenza:picklistvalue>
          <avenza:picklistvalue><![CDATA[Inscription 1er niveau]]></avenza:picklistvalue>
          <avenza:picklistvalue><![CDATA[Inscription 3e niveau]]></avenza:picklistvalue>
          <avenza:picklistvalue><![CDATA[Inscription 2e niveau]]></avenza:picklistvalue>
          <avenza:picklistvalue><![CDATA[Curiosité]]></avenza:picklistvalue>
          <avenza:picklistvalue><![CDATA[Puits à eau]]></avenza:picklistvalue>
    </avenza:picklist>
    <avenza:picklist schemaUrl="schemPOI" avenza:field="Inspecteur / Architecte">
          <avenza:picklistvalue><![CDATA[François Mansart]]></avenza:picklistvalue>
          <avenza:picklistvalue><![CDATA[Charles-Axel Guillaumot]]></avenza:picklistvalue>
          <avenza:picklistvalue><![CDATA[Demoustier]]></avenza:picklistvalue>
          <avenza:picklistvalue><![CDATA[Antoine Dupont]]></avenza:picklistvalue>
          <avenza:picklistvalue><![CDATA[Bralle]]></avenza:picklistvalue>
          <avenza:picklistvalue><![CDATA[Blavier]]></avenza:picklistvalue>
          <avenza:picklistvalue><![CDATA[Du Souich]]></avenza:picklistvalue>
          <avenza:picklistvalue><![CDATA[Descottes]]></avenza:picklistvalue>
          <avenza:picklistvalue><![CDATA[Roger]]></avenza:picklistvalue>
          <avenza:picklistvalue><![CDATA[Gentil]]></avenza:picklistvalue>
          <avenza:picklistvalue><![CDATA[Wickersheimer]]></avenza:picklistvalue>
          <avenza:picklistvalue><![CDATA[Weiss]]></avenza:picklistvalue>
          <avenza:picklistvalue><![CDATA[Lantillon]]></avenza:picklistvalue>
          <avenza:picklistvalue><![CDATA[Commission]]></avenza:picklistvalue>
          <avenza:picklistvalue><![CDATA[Juncker]]></avenza:picklistvalue>
          <avenza:picklistvalue><![CDATA[Jacquot]]></avenza:picklistvalue>
          <avenza:picklistvalue><![CDATA[De Hennezel]]></avenza:picklistvalue>
          <avenza:picklistvalue><![CDATA[Duchemin]]></avenza:picklistvalue>
          <avenza:picklistvalue><![CDATA[Héricart de Thury]]></avenza:picklistvalue>
          <avenza:picklistvalue><![CDATA[De Fourcy]]></avenza:picklistvalue>
          <avenza:picklistvalue><![CDATA[O. KELLER]]></avenza:picklistvalue>
      </avenza:picklist>
          <avenza:picklist schemaUrl="schemPOI" avenza:field="Type D’inscription">
          <avenza:picklistvalue><![CDATA[Consolidation]]></avenza:picklistvalue>
          <avenza:picklistvalue><![CDATA[Metropolitain]]></avenza:picklistvalue>
          <avenza:picklistvalue><![CDATA[Dessin]]></avenza:picklistvalue>
          <avenza:picklistvalue><![CDATA[Épure]]></avenza:picklistvalue>
          <avenza:picklistvalue><![CDATA[Fusain]]></avenza:picklistvalue>
          <avenza:picklistvalue><![CDATA[Indication altimétrique]]></avenza:picklistvalue>
          <avenza:picklistvalue><![CDATA[Indication topographique]]></avenza:picklistvalue>
          <avenza:picklistvalue><![CDATA[Sanguine]]></avenza:picklistvalue>
          <avenza:picklistvalue><![CDATA[Voie]]></avenza:picklistvalue>
          <avenza:picklistvalue><![CDATA[Pienture]]></avenza:picklistvalue>
          <avenza:picklistvalue><![CDATA[Sculpture]]></avenza:picklistvalue>
      </avenza:picklist>
    </ExtendedData>
  <Folder>
      <styleUrl>#style0</styleUrl>
      <name>P.O.I</name>
      <ExtendedData>
        <SchemaData schemaUrl="#schemPOI"/>
      </ExtendedData>
' > POI.kml

cat POITemp.kml| awk 'NF' | awk '!/P.O.I"><\/SimpleData>/'| awk '!/inscription"><\/SimpleData>/'| awk '!/Architecte"><\/SimpleData>/'| awk '!/Commentaire"><\/SimpleData>/'| awk '!/Création"><\/SimpleData>/'| awk '!/NodeID"><\/SimpleData>/'| awk '!/VID"><\/SimpleData>/'| awk '!/Vuuid"><\/SimpleData>/'| awk '!/Description"><\/SimpleData>/' >> POI.kml
rm POITemp.kml

echo -e '    </Folder>
    <Style id="ISc3">
      <IconStyle>
        <Icon>
           <scale>10</scale>
          <href>https://raw.githubusercontent.com/babinet/InOutNOutIn/main/SVG/ISc3.svg</href>
        </Icon>
      </IconStyle>
    </Style>
    <Style id="ISc2">
      <IconStyle>
        <Icon>
           <scale>10</scale>
          <href>https://raw.githubusercontent.com/babinet/InOutNOutIn/main/SVG/ISc2.svg</href>
        </Icon>
      </IconStyle>
    </Style>
    <Style id="ISc1">
      <IconStyle>
        <Icon>
           <scale>10</scale>
          <href>https://raw.githubusercontent.com/babinet/InOutNOutIn/main/SVG/ISc1.svg</href>
        </Icon>
      </IconStyle>
    </Style>
    <Style id="CRs">
      <IconStyle>
        <Icon>
           <scale>10</scale>
          <href>https://raw.githubusercontent.com/babinet/InOutNOutIn/main/SVG/CRs.svg</href>
        </Icon>
      </IconStyle>
    </Style>
    <Style id="A">
      <IconStyle>
        <Icon>
           <scale>10</scale>
          <href>https://raw.githubusercontent.com/babinet/InOutNOutIn/main/SVG/A.svg</href>
        </Icon>
      </IconStyle>
    </Style>
    <Style id="PE">
      <IconStyle>
        <Icon>
           <scale>10</scale>
          <href>https://raw.githubusercontent.com/babinet/InOutNOutIn/main/SVG/PE.svg</href>
        </Icon>
      </IconStyle>
    </Style>
    <Style id="LD">
      <IconStyle>
        <Icon>
           <scale>10</scale>
          <href>https://raw.githubusercontent.com/babinet/InOutNOutIn/main/SVG/LD.svg</href>
        </Icon>
      </IconStyle>
    </Style>
    
</Document>
</kml>' >> POI.kml
gpsbabel -w -i kml -f POI.kml -o gpx -F POI.gpx
ogr2ogr -f GeoJSON POI.json POI.kml
mv POI.gpx "$FileDate"_P.O.I.gpx
mv POI.kml "$FileDate"_P.O.I.kml
mv POI.json "$FileDate"_P.O.I.json
zip P.O.I.zip *_P.O.I.*
cd -
