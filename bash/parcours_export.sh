# Sous Ubuntu
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





tr -d '\n' < AllNodes.txt | sed 's/(object) array(/\
(object) array(/g' | awk '{gsub("'\'',\ \ \ \ \ \ '\''", "|"); print}' | awk '{gsub("\",\ \ \ \ \ \ '\''", "|"); print}'> AllNodesTMP.csv

cat "AllNodesTMP.csv" | awk 'NF' | awk 'FNR == 2 {print}' >> NodeParcours.csv

FileDate=$(echo $(date +%Y_%m_%d) | tr "/" "_")
while read -r linecsv
do
# NODE INFO + DATA
substringfields=$(echo "$linecsv" | awk -F'|' '{print $20}' )
NodeTitle=$(echo -e "$linecsv" | awk -F'|' '{print $3}' | sed "s/title' => //g" | sed 's/^"//g' | sed "s/^'//g" | awk 'FNR == 1' | sed 's/&/et/g')
NodeID=$(echo -e "$linecsv" | awk -F'nid'\'' => '\''' '{print $2}' | awk -F'|' '{print $1}' | awk 'NF')
NodeVID=$(echo -e "$linecsv" | awk -F'vid'\'' => '\''' '{print $2}' | awk -F'|' '{print $1}' | awk 'NF')
Vuuid=$(echo -e "$linecsv" | awk -F'vuuid'\'' => '\''' '{print $2}' | awk -F'|' '{print $1}' | awk 'NF')
Date=$(echo -e "$linecsv" | awk -F'created'\'' => '\''' '{print $2}' | awk -F'|' '{print $1}' | awk 'NF')
RevisionTimestamp=$(echo -e "$linecsv" | awk -F'changed'\'' => '\''' '{print $2}' | awk -F'|' '{print $1}' | awk 'NF')




CreatedDatetmp=$(date -d @$Date | sed 's/CET //g'| sed 's/UTC //g' | sed 's/CEST //g')
# KML DATE FORMAT
CreatedDate=$(date -d "$CreatedDatetmp" +"%Y-%m-%dT%H:%M:%S+01:00")
LastRevisionTimestamptmp=$(date -d @$RevisionTimestamp | sed 's/CET //g'| sed 's/UTC //g' | sed 's/CEST //g')
# KML DATE FORMAT
LastRevisionTimestamp=$(date -d "$LastRevisionTimestamptmp" +"%Y-%m-%dT%H:%M:%S+01:00")

coordinates4326tmp=$(echo "$linecsv" | awk -F'|' '{print $20}' | awk -F''\''geometry'\'' => '\''' '{print $2}' | awk -F''\''' '{print $1}' | awk 'NF' | /usr/local/bin/geomet)

WKT27561=$(echo "$coordinates4326tmp" |awk -F']], "crs": {"properties":' '{print $1}' | tr ']' '\n' | tr -d '][' | awk '{print $2, $3","0}' | tr -d '\ ' | tr ',' ' ' |awk '{print $0}' | gdaltransform -s_srs EPSG:4326 -t_srs EPSG:27561 | awk '{print $0","}' |tr '\n' ' '| awk '{print "LINESTRING ("$0")"}' | sed 's/0, )/0)/g' | sed 's/, )/ )/g')
sed "s/STRINGTOREPLACE/'$WKT27561'/g" Model.py | tr -d "'" > WKT.py
DistanceMetres=$(/usr/bin/python2.7 WKT.py | sed 's/Length = //g')
DistanceMetresHumanR=$(echo $DistanceMetres | awk -F. '{print $1"."substr($2,1,2)}')
#Distancepied Charlemagne post 1668
Distancepied=$(echo $DistanceMetres/0.324839|bc -l)
DistanceToises=$(echo $Distancepied/6|bc -l)
DistancePiedsDeRoi=$(echo $DistanceToises| awk -F'.' '{print "0."$2"*6"}'|bc -l|awk -F'.' '{print $1}')
DistanceToisesRounded=$(echo $DistanceToises| awk -F'.' '{print $1}')
DistancePouces=$(echo $DistanceToises | awk -F'.' '{print "0."$2"*12"}'|bc -l)

if [ -z "$DistancePouces" ]
then
cestlepouce="0"
else
cestlepouce=$(echo $DistancePouces | awk -F'.' '{print $1}' )
fi

if [ -z "$DistancePiedsDeRoi" ]
then
cestlepied="0"
else
cestlepied=$(echo "$DistancePiedsDeRoi" |awk -F'.' '{print $1}' )
fi

DistanceEnMetres=$(echo "Distance du parcours en mètres $DistanceMetresHumanR métres")
DistanceRoyaleafter1668=$(echo "$DistanceToisesRounded Toises "$cestlepied" Pieds du roi "$cestlepouce" Pouce(s)")

#Distance pied Ancien post 1668
DistancepiedBefore1668=$(echo $DistanceMetres/0.326596|bc -l)
DistanceToisesBefore1668=$(echo $DistancepiedBefore1668/6|bc -l)
DistancePiedsDeRoiBefore1668=$(echo $DistanceToisesBefore1668| awk -F'.' '{print "0."$2"*6"}'|bc -l|awk -F'.' '{print $1}')
DistanceToisesRoundedBefore1668=$(echo $DistanceToisesBefore1668| awk -F'.' '{print $1}')
DistancePoucesBefore1668=$(echo $DistanceToisesRoundedBefore1668 | awk -F'.' '{print "0."$2"*12"}'|bc -l|awk -F'.' '{print $1}')

if [ -z "$DistancePoucesBefore1668" ]
then
cestlepoucedavant="0"
else
cestlepoucedavant=$(echo $DistancePoucesBefore1668 | awk -F'.' '{print $1}' )
fi

if [ -z "$DistancePiedsDeRoiBefore1668" ]
then
cestlepiedavant="0"
else
cestlepiedavant=$(echo "$DistancePiedsDeRoiBefore1668" |awk -F'.' '{print $1}' )
fi

#Distance Yards ft in source : 0.3048 m
DistancepiedTotalFt=$(echo $DistanceMetres/0.3048|bc -l)
DistanceYards=$(echo $DistancepiedTotalFt/3|bc -l)
ftuk=$(echo $DistancepiedTotalFt| awk -F'.' '{print "0."$2"*3"}'|bc -l|awk -F'.' '{print $1}')
DistanceInches=$(echo $ftuk | awk -F'.' '{print "0."$2"*12"}'|bc -l|awk -F'.' '{print $1}')
DistanceYardsRounded=$(echo $DistanceYards| awk -F'.' '{print $1}')

if [ -z "$DistanceInches" ]
then
inches="0"
else
inches=$(echo $DistanceInches | awk -F'.' '{print $1}' )
fi


if [ -z "$ftuk" ]
then
ft="0"
else
ft=$(echo "$ftuk" |awk -F'.' '{print $1}' )
fi

DistanceRoyaleBefore1668=$(echo "Distance du parcours pieds de roi anté 1668 = "$DistanceToisesRoundedBefore1668" Toises "$cestlepiedavant" Pieds du roi "$cestlepoucedavant" Pouce(s)")
DistanceRoyaleafter1668=$(echo "Distance du parcours pieds de roi post 1668 = "$DistanceToisesRounded" Toises "$cestlepied" Pieds du roi "$cestlepouce" Pouce(s)")
USAUK=$(echo "Distance UK / U.S.A : Yd / Ft / In  = "$DistanceYardsRounded" yd "$ft" ft "$inches" in")

echo "${white}$USAUK USAUK${red}
DistanceRoyaleBefore1668 $DistanceRoyaleBefore1668
DistanceMetres $DistanceMetres
DistanceMetresHumanR $DistanceMetresHumanR $white"
coordinates4326=$( echo "$coordinates4326tmp" |awk -F']], "crs": {"properties":' '{print $1}' | tr ']' '\n' | tr -d '][' | awk '{print $2, $3","0}' | tr -d '\ ')
body=$(printf "$substringfields" | tr -d '\n'| awk -F'body' '{print $2}' |  awk -F'value'\'' => "'  '{print $2}' | awk -F'",            '\''summary'\'' =>' '{print $1}' | sed 's/<p/\
<p/'g  | sed 's/<\/p/\
<\/p/'g | sed 's/<span/\
<span/'g  | sed 's/<\/span/\
<\/span/'g| sed 's/<div/\
<div/'g| sed 's/<br/\
<br/'g| sed 's/<\/div/\
<\/div/'g | sed 's/>/>\
/'g | sed 's/&nbsp;//g' | awk '!/<span/' | awk '!/<\/span/' | awk '!/<p/'| awk '!/<\/p/'| awk '!/<\/div/'| awk '!/<div/' | awk 'NF')
echo "<Placemark>
        <name>"$NodeTitle"</name>
        <styleUrl>#"$StyleKml"</styleUrl>
        <ExtendedData>
          <SchemaData schemaUrl=\"#schemaParcours\">
            <SimpleData name=\"Distance métres\">$DistanceEnMetres</SimpleData>
            <SimpleData name=\"Distance UK - USA\">$USAUK</SimpleData>
            <SimpleData name=\"Distance pieds de roi post-1668\">$DistanceRoyaleafter1668</SimpleData>
            <SimpleData name=\"Distance pieds de roi anté-1668\">$DistanceRoyaleBefore1668</SimpleData>
            <SimpleData name=\"Commentaire\"></SimpleData>
            <SimpleData name=\"Date de Création\"><when>$CreatedDate</when></SimpleData>
            <SimpleData name=\"Dernier Revision\"><when>$LastRevisionTimestamp</when></SimpleData>
            <SimpleData name=\"NodeID\">$NodeID</SimpleData>
            <SimpleData name=\"VID\">$NodeVID</SimpleData>
            <SimpleData name=\"Vuuid\">$Vuuid</SimpleData>
            <SimpleData name=\"Eau\"></SimpleData>
            <SimpleData name=\"Description\">$body</SimpleData>
            <TimeStamp><when></when></TimeStamp>
          </SchemaData>
        </ExtendedData>
        <LineString>
          <coordinates>$coordinates4326</coordinates>
        </LineString>
      </Placemark>" | tr -d '\r' | grep -v "^$" >> ParcoursTemp.kml
done < NodeParcours.csv

echo '<?xml version="1.0" encoding="UTF-8"?>
<kml xmlns="http://www.opengis.net/kml/2.2" xmlns:gx="http://www.google.com/kml/ext/2.2">
  <Document>
    <Schema id="schemaParcours" name="schemaParcours">
      <SimpleField name="Description" type="string"/>
      <SimpleField name="Commentaire" type="string"/>
      <SimpleField name="Eau" type="string"/>
      <SimpleField name="Distance métres" type="string"/>
      <SimpleField name="Distance UK - USA" type="string"/>
      <SimpleField name="Distance pieds de roi post 1668" type="string"/>
      <SimpleField name="Distance pieds de roi anté 1668" type="string"/>
      <SimpleField name="NodeID" type="string"/>
      <SimpleField name="VID" type="string"/>
      <SimpleField name="Vuuid" type="string"/>
    </Schema>
    <ExtendedData xmlns:avenza="http://www.avenza.com">
     <avenza:picklist schemaUrl="schemaParcours" avenza:field="Eau">
          <avenza:picklistvalue><![CDATA[Pieds Secs]]></avenza:picklistvalue>
          <avenza:picklistvalue><![CDATA[Bottes]]></avenza:picklistvalue>
          <avenza:picklistvalue><![CDATA[Cuissardes]]></avenza:picklistvalue>
          <avenza:picklistvalue><![CDATA[Inondé]]></avenza:picklistvalue>
      </avenza:picklist>
    </ExtendedData>
    <Folder>
      <styleUrl>#style0</styleUrl>
      <name>Parcours</name>
      <ExtendedData>
        <SchemaData schemaUrl="#schemaParcours"/>
      </ExtendedData>
' > Parcours.kml
# LOOP END
cat ParcoursTemp.kml| awk 'NF' >> Parcours.kml
rm ParcoursTemp.kml

echo '    </Folder>
    <Style id="CDM">
      <IconStyle>
        <Icon>
           <scale>10</scale>
          <href>https://raw.githubusercontent.com/babinet/InOutNOutIn/main/Img/logo_white.png</href>
        </Icon>
      </IconStyle>
    </Style>
</Document>
</kml>' >> Parcours.kml
gpsbabel -w -i kml -f Parcours.kml -o gpx -F Parcours.gpx
ogr2ogr -f GeoJSON Parcours.json Parcours.kml
mv Parcours.gpx "$FileDate"_Parcours.gpx
mv Parcours.kml "$FileDate"_Parcours.kml
mv Parcours.json "$FileDate"_Parcours.json
zip Parcours.zip *_Parcours.*


cd -
