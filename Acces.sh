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
NodeTitle=$(echo -e "$linecsv" | awk -F'|' '{print $3}' | sed "s/title' => //g" | sed 's/^"//g' | sed "s/^'//g" | awk 'FNR == 1' | sed 's/&/et/g')
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

# F#cking Date on Mac OS X (Condition)
System=$(uname)
if [ "$System" == "Darwin" ]
then
echo "Date MAC OS X condition"
CreatedDatetmp=$(date -r $Date | sed 's/CET //g'| sed 's/UTC //g' | sed 's/CEST //g')
# KML DATE FORMAT
CreatedDate=$(date -jf"%a %b %e %H:%M:%S %Y" "$CreatedDatetmp" +"%Y-%m-%dT%H:%M:%S+01:00")
LastRevisionTimestamptmp=$(date -r $RevisionTimestamp | sed 's/CET //g'| sed 's/UTC //g' | sed 's/CEST //g')
# KML DATE FORMAT
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
echo -e "${white}---> \$TypeGeom                ----- ------ ------ ------ ------> ${orange}"$TypeGeom""
TypeDacces=$(echo -e "$substringfields" | awk -F'field_type_acces' '{print $2}' | awk -F'tid'\'' => '\''' '{print $2}'| awk -F''\''' '{print $1}' |awk 'NF')
echo -e "${white}---> \$TypeDacces              ----- ------ ------ ------ ------> ${orange}"$TypeDacces""
Hauteur=$(echo -e "$substringfields" | awk -F'field_hauteur' '{print $2}' |  awk -F'value'\'' => '\'''  '{print $2}' | awk -F''\'',' '{print $1}' |awk 'NF' | awk '{print $1}')
echo -e "${white}---> \$Hauteur                 ----- ------ ------ ------ ------> ${purple}"$Hauteur""
OpenClosed=$(echo -e "$substringfields" | awk -F'field_etat_acces' '{print $2}' |  awk -F'tid'\'' => '\'''  '{print $2}' | awk -F''\'',' '{print $1}' |awk 'NF')
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
#body=$(cat "body.txt"| awk 'NF')
echo -e "---> \$body  ------ ------ ------ ------ ------> "$body""
if [[ "$TypeDacces" == 294 ]]
then
TypeDaccesABC=$(echo -e "Puits de service (PS)")
IconAcces=$(echo "https://raw.githubusercontent.com/babinet/InOutNOutIn/main/SVG/PS.svg")
echo -e "${white}---> Type d'accès : ${orange}Puits de service (PS)"
StyleKml="PS"
fi
if [[ "$TypeDacces" == 295 ]]
then
TypeDaccesABC=$(echo -e "Entrée en cavage (EC)")
IconAcces=$(echo "https://raw.githubusercontent.com/babinet/InOutNOutIn/main/SVG/EC.svg")
StyleKml="EC"
echo -e "${white}---> Type d'accès : ${orange}Entrée en cavage (EC)"
fi
if [[ "$TypeDacces" == 296 ]]
then
TypeDaccesABC=$(echo -e "Escalier circulaire (ESc)")
IconAcces=$(echo "https://raw.githubusercontent.com/babinet/InOutNOutIn/main/SVG/ESc.svg")
StyleKml="ESc"
echo -e "${white}---> Type d'accès : ${orange}Escalier circulaire (ESc)"
fi
if [[ "$TypeDacces" == 297 ]]
then
TypeDaccesABC=$(echo -e "Escalier droit (ESd)")
IconAcces=$(echo "https://raw.githubusercontent.com/babinet/InOutNOutIn/main/SVG/ESd.svg")
StyleKml="ESd"
echo -e "${white}---> Type d'accès : ${orange}Escalier droit (ESd)"
fi
if [[ "$TypeDacces" == 298 ]]
then
TypeDaccesABC=$(echo -e "Galerie technique, autre (GT)")
IconAcces=$(echo "https://raw.githubusercontent.com/babinet/InOutNOutIn/main/SVG/GT.svg")
StyleKml="GT"
echo -e "${white}---> Type d'accès : ${orange}Galerie technique, autre (GT)"
fi
if [[ "$TypeDacces" == 299 ]]
then
TypeDaccesABC=$(echo -e "Raccordement aux carrières (RC)")
IconAcces=$(echo "https://raw.githubusercontent.com/babinet/InOutNOutIn/main/SVG/RC.svg")
StyleKml="RC"
echo -e "${white}---> Type d'accès : ${orange}Raccordement aux carrières (RC)"
fi
if [[ "$TypeDacces" == 300 ]]
then
TypeDaccesABC=$(echo -e "Puits de service comblé (PSc)")
IconAcces=$(echo "https://raw.githubusercontent.com/babinet/InOutNOutIn/main/SVG/PSc.svg")
StyleKml="PSc"
echo -e "${white}---> Type d'accès : ${orange}Puits de service comblé (PSc)"
fi
if [[ "$TypeDacces" == 301 ]]
then
TypeDaccesABC=$(echo -e "Lunette (Lte)")
IconAcces=$(echo "https://raw.githubusercontent.com/babinet/InOutNOutIn/main/SVG/Lte.svg")
StyleKml="Lte"
echo -e "${white}---> Type d'accès : ${orange}Lunette (Lte)"
fi
if [[ "$TypeDacces" == 309 ]]
then
TypeDaccesABC=$(echo -e "Puits de service à échelons (PSé)")
IconAcces=$(echo "https://raw.githubusercontent.com/babinet/InOutNOutIn/main/SVG/PSe.svg")
StyleKml="PSe"
echo -e "${white}---> Type d'accès : ${orange}Puits de service à échelons (PSé)"
fi

####
# Ouvert/fermé 307 = ouvert 308 = fermé
if [[ "$OpenClosed" == 307 ]]
then
Ouvert=1
echo -e "${white}---> État : ${orange}Ouvert 1"
fi
if [[ "$OpenClosed" == 308 ]]
then
Ouvert=0
echo -e "${white}---> État : ${orange}Fermé (0)"
fi

echo -e "     <Placemark>
        <name>"$NodeTitle"</name>
        <styleUrl>#"$StyleKml"</styleUrl>
        <ExtendedData>
          <SchemaData schemaUrl=\"#schemaAccess\">
            <SimpleData name=\"Type d’accès\">"$TypeDaccesABC"</SimpleData>
            <SimpleData name=\"Description\">$body</SimpleData>
            <SimpleData name=\"Commentaire\"></SimpleData>
            <SimpleData name=\"Accessible\">$Ouvert</SimpleData>
            <SimpleData name=\"Hauteur\">$Hauteur m</SimpleData>
            <SimpleData name=\"Nombre de marches\"></SimpleData>
            <SimpleData name=\"Date de Création\"><when>$CreatedDate</when></SimpleData>
            <SimpleData name=\"Dernier Revision\"><when>$LastRevisionTimestamp</when></SimpleData>
            <SimpleData name=\"NodeID\">$NodeID</SimpleData>
            <SimpleData name=\"VID\">$NodeVID</SimpleData>
            <SimpleData name=\"Vuuid\">$Vuuid</SimpleData>
            <TimeStamp><when></when></TimeStamp>
          </SchemaData>
        </ExtendedData>
        <Point>
          <coordinates>$coordinates4326</coordinates>
        </Point>
      </Placemark>" >> AccesTemp.kml
done < NodeAcces.csv

echo -e '<?xml version="1.0" encoding="UTF-8"?>
<kml xmlns="http://www.opengis.net/kml/2.2" xmlns:gx="http://www.google.com/kml/ext/2.2">
  <Document>
    <Schema id="schemaAccess" name="SchemaAccess">
      <SimpleField name="Type d’accès" type="string"/>
      <SimpleField name="Description" type="string"/>
      <SimpleField name="pdfmaps_photos" type="string">
        <displayName>Photos</displayName>
      </SimpleField>
      <SimpleField name="Commentaire" type="string"/>
      <SimpleField name="Accessible" type="bool"/>
      <SimpleField name="Hauteur" type="string"/>
      <SimpleField name="Nombre de marches" type="string"/>
      <SimpleField name="Nombre d’échelons" type="string"/>
      <SimpleField name="NodeID" type="string"/>
      <SimpleField name="VID" type="string"/>
      <SimpleField name="Vuuid" type="string"/>
    </Schema>
    <ExtendedData xmlns:avenza="http://www.avenza.com">
     <avenza:picklist schemaUrl="schemaAccess" avenza:field="Type d’accès">
          <avenza:picklistvalue><![CDATA[Escalier Circulaire (ECc)]]></avenza:picklistvalue>
          <avenza:picklistvalue><![CDATA[Escalier Droit (ESd)]]></avenza:picklistvalue>
          <avenza:picklistvalue><![CDATA[Puits de Service (PS)]]></avenza:picklistvalue>
          <avenza:picklistvalue><![CDATA[Puits de Service à Échelons (PSé)]]></avenza:picklistvalue>
          <avenza:picklistvalue><![CDATA[Galerie Technique, autre (GT)]]></avenza:picklistvalue>
          <avenza:picklistvalue><![CDATA[Entrée en Cavage (EC)]]></avenza:picklistvalue>
          <avenza:picklistvalue><![CDATA[Raccordement aux Carrières (RC)]]></avenza:picklistvalue>
          <avenza:picklistvalue><![CDATA[Lunette (Lte)]]></avenza:picklistvalue>
      </avenza:picklist>
    </ExtendedData>
    <Folder>
      <styleUrl>#style0</styleUrl>
      <name>Accès</name>
      <ExtendedData>
        <SchemaData schemaUrl="#schemaAccess"/>
      </ExtendedData>
' > Acces.kml
# LOOP END
cat AccesTemp.kml| awk 'NF' >> Acces.kml
rm AccesTemp.kml

echo -e '    </Folder>
    <Style id="ESd">
      <IconStyle>
        <Icon>
           <scale>10</scale>
          <href>https://raw.githubusercontent.com/babinet/InOutNOutIn/main/Img/ESd.png</href>
        </Icon>
      </IconStyle>
    </Style>
    <Style id="PS">
      <IconStyle>
        <Icon>
           <scale>10</scale>
          <href>https://raw.githubusercontent.com/babinet/InOutNOutIn/main/Img/PS.png</href>
        </Icon>
      </IconStyle>
    </Style>
    <Style id="PSc">
      <IconStyle>
        <Icon>
           <scale>10</scale>
          <href>https://raw.githubusercontent.com/babinet/InOutNOutIn/main/Img/PSc.png</href>
        </Icon>
      </IconStyle>
    </Style>
    <Style id="PSe">
      <IconStyle>
        <Icon>
           <scale>10</scale>
          <href>https://raw.githubusercontent.com/babinet/InOutNOutIn/main/Img/PSe.png</href>
        </Icon>
      </IconStyle>
    </Style>
    <Style id="ESc">
      <IconStyle>
        <Icon>
           <scale>10</scale>
          <href>https://raw.githubusercontent.com/babinet/InOutNOutIn/main/Img/ESc.png</href>
        </Icon>
      </IconStyle>
    </Style>
    <Style id="EC">
      <IconStyle>
        <Icon>
           <scale>10</scale>
          <href>https://raw.githubusercontent.com/babinet/InOutNOutIn/main/Img/EC.png</href>
        </Icon>
      </IconStyle>
    </Style>
    <Style id="GT">
      <IconStyle>
        <Icon>
           <scale>10</scale>
          <href>https://raw.githubusercontent.com/babinet/InOutNOutIn/main/Img/GT.png</href>
        </Icon>
      </IconStyle>
    </Style>
    <Style id="Lte">
      <IconStyle>
        <Icon>
           <scale>10</scale>
          <href>https://raw.githubusercontent.com/babinet/InOutNOutIn/main/Img/Lte.png</href>
        </Icon>
      </IconStyle>
    </Style>
    <Style id="RC">
      <IconStyle>
        <Icon>
           <scale>10</scale>
          <href>https://raw.githubusercontent.com/babinet/InOutNOutIn/main/Img/EC.png</href>
        </Icon>
      </IconStyle>
    </Style>
    <Style id="CDM">
      <IconStyle>
        <Icon>
           <scale>10</scale>
          <href>https://raw.githubusercontent.com/babinet/InOutNOutIn/main/Img/logo_white.png</href>
        </Icon>
      </IconStyle>
    </Style>' > Acces.kml
gpsbabel -w -i kml -f Acces.kml -o gpx -F Acces.gpx
ogr2ogr -f GeoJSON Acces.json Acces.kml
mv Acces.gpx "$FileDate"_Acces.gpx
mv Acces.kml "$FileDate"_Acces.kml
mv Acces.json "$FileDate"_Acces.json
zip Acces.zip *_Acces.*
cd -
