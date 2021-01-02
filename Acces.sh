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
while read -re linecsv
do
# NODE INFO + DATA
NodeTitle=$(echo -e "$linecsv" | awk -F'|' '{print $3}' | sed "s/title' => //g" | sed 's/^"//g' | sed "s/^'//g")
echo -e "---> \$NodeTitle  ----- ------ ------ ------ ------> $NodeTitle"

#echo -e "$linecsv" | awk -F'|' -v NodeTitle='$NodeTitle' '{print $1, $2, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, $16, $17, $18, $19, $21; $22; $23}' OFS='|' | sed "s/'vid' \=> '//g" | sed "s/uid' \=> '//g" | sed "s/title' => //g" | sed 's/^"//g' | sed "s/^'//g" | sed "s/status' => '//g" | sed "s/log' => '//g" | sed "s/comment' => '//g" | sed "s/promote' => '//g" | sed "s/promote' => '//g" | sed "s/sticky' => '//g" | sed "s/nid' => '//g" | sed "s/type' => '//g" | sed "s/language' => '//g" | sed "s/created' => '//g" | sed "s/changed' => '//g" | sed "s/translate' => '//g" | sed "s/revision_timestamp' => '//g" | sed "s/revision_timestamp' => '//g" | sed "s/last_comment_timestamp' => '//g"
#echo -e "$linecsv" | awk -F'|' '{print $20}' | awk -F''\''geometry'\'' => '\''' '{print $2}' | awk -F''\''' '{print $1}' | awk 'NF' | geomet

substringfields=$(echo "$linecsv" | awk -F'|' '{print $20}' )
# GEOMERTY
echo -e "---> \$substringfields  ------ ------ ------ ------> $substringfields"
substringfieldsGeom=$(echo "$linecsv" | awk -F'|' '{print $20}' | awk -F''\''geometry'\'' => '\''' '{print $2}' | awk -F''\''' '{print $1}' | awk 'NF' | geomet )
#echo -e "$orange A  $substringfields $white"
#echo "$linecsv" | awk -F'|' '{print $20}' | awk -F''\''geometry'\'' => '\''' '{print $2}' | awk -F''\''' '{print $1}' | awk 'NF' | geomet

SRSID=$(echo -e "$substringfieldsGeom" | awk -F'\"name\": \"EPSG' '{print $2}' | awk -F''\"'' '{print $1}')
coordinates3857=$(echo -e "$substringfieldsGeom" | awk -F'coordinates\": ' '{print $2}' | awk -F', \"' '{print $1}' | tr -d '[]' )
echo -e "---> \$coordinates ---- ------ ------ ------ ------> "$coordinates""
TypeGeom=$(echo -e "$substringfieldsGeom" | awk -F'"srid": ' '{print $2}' | awk -F'\"type\": \"' '{print $2}' | awk -F'\"' '{print $1}')
echo -e "---> \$TypeGeom  ------ ------ ------ ------ ------> "$TypeGeom""
TypeDacces=$(echo -e "$substringfields" | awk -F'field_type_acces' '{print $2}' | awk -F'tid'\'' => '\''' '{print $2}'| awk -F''\''' '{print $1}' |awk 'NF')
echo -e "---> \$TypeDacces  ------ ------ ------ ------ ------> "$TypeDacces""
#'field_type_acces' => array(        'und' => array(          array(            'tid' => '294',

#echo $coordinates3857 coordinates3857
coordinates4326=$(echo "$coordinates3857"| gdaltransform -s_srs EPSG:3857 -t_srs EPSG:4326 | sed 's/\ /\,/g')
if [[ "$TypeDacces" == 294 ]]
then
TypeDaccesABC=$(echo -e "Puits de service (PS)")
IconAcces=$(echo "https://carto.sous-paris.com/sites/all/themes/cdm/css/img/h50/PS.png")
echo -e "${white}---> Type d'accès : ${orange}Puits de service (PS)"
StyleKml="PS"
fi
if [[ "$TypeDacces" == 295 ]]
then
TypeDaccesABC=$(echo -e "Entrée en cavage (EC)")
IconAcces=$(echo "https://carto.sous-paris.com/sites/all/themes/cdm/css/img/h50/EC.png")
StyleKml="EC"
echo -e "${white}---> Type d'accès : ${orange}Entrée en cavage (EC)"
fi
if [[ "$TypeDacces" == 296 ]]
then
TypeDaccesABC=$(echo -e "Escalier circulaire (ESc)")
IconAcces=$(echo "https://carto.sous-paris.com/sites/all/themes/cdm/css/img/h50/ESc.png")
StyleKml="ESc"
echo -e "${white}---> Type d'accès : ${orange}Escalier circulaire (ESc)"
fi
if [[ "$TypeDacces" == 297 ]]
then
TypeDaccesABC=$(echo -e "Escalier droit (ESd)")
IconAcces=$(echo "https://carto.sous-paris.com/sites/all/themes/cdm/css/img/h50/ESd.png")
StyleKml="ESd"
echo -e "${white}---> Type d'accès : ${orange}Escalier droit (ESd)"
fi
if [[ "$TypeDacces" == 298 ]]
then
TypeDaccesABC=$(echo -e "Galerie technique, autre (GT)")
IconAcces=$(echo "https://carto.sous-paris.com/sites/all/themes/cdm/css/img/h50/GT.png")
StyleKml="GT"
echo -e "${white}---> Type d'accès : ${orange}Galerie technique, autre (GT)"
fi
if [[ "$TypeDacces" == 299 ]]
then
TypeDaccesABC=$(echo -e "Raccordement aux carrières (RC)")
IconAcces=$(echo "https://carto.sous-paris.com/sites/all/themes/cdm/css/img/h50/RC.png")
StyleKml="RC"
echo -e "${white}---> Type d'accès : ${orange}Raccordement aux carrières (RC)"
fi
if [[ "$TypeDacces" == 300 ]]
then
TypeDaccesABC=$(echo -e "Puits de service comblé (PSc)")
IconAcces=$(echo "https://carto.sous-paris.com/sites/all/themes/cdm/css/img/h50/PSc.png")
StyleKml="PSc"
echo -e "${white}---> Type d'accès : ${orange}Puits de service comblé (PSc)"
fi
if [[ "$TypeDacces" == 301 ]]
then
TypeDaccesABC=$(echo -e "Lunette (Lte)")
IconAcces=$(echo "https://carto.sous-paris.com/sites/all/themes/cdm/css/img/h32/lunettes.png")
StyleKml="Lte"
echo -e "${white}---> Type d'accès : ${orange}Lunette (Lte)"
fi
if [[ "$TypeDacces" == 309 ]]
then
TypeDaccesABC=$(echo -e "Puits de service à échelons (PSé)")
IconAcces=$(echo "https://carto.sous-paris.com/sites/all/themes/cdm/css/img/h50/PSe.png")
StyleKml="PSe"
echo -e "${white}---> Type d'accès : ${orange}Puits de service à échelons (PSé)"
fi

echo -e "     <Placemark>
        <name>"$NodeTitle"</name>
        <styleUrl>\#"$StyleKml"</styleUrl>
        <ExtendedData>
          <SchemaData schemaUrl="#schemaAccess">
            <SimpleData name="Description">Escalier droit en pierres de tailles. Controlé par l’école du service de santé des armées du Val-de-Grâce / France Domaine</SimpleData>
            <SimpleData name="Commentaire">Verrouillé en trois points</SimpleData>
            <SimpleData name="État">0</SimpleData>
            <SimpleData name="Hauteur">18,9969m</SimpleData>
            <SimpleData name="Nombre de marches">128</SimpleData>
            <SimpleData name="Type d’accès">"$TypeDaccesABC"</SimpleData>
          </SchemaData>
        </ExtendedData>
        <Point>
          <coordinates>
            $coordinates4326
          </coordinates>
        </Point>
      </Placemark>" >> AccesTemp.kml

#echo -e "${orange}$NodeTitle|${white} SUBSTRING $substringfields|$purple $TypeDaccesABC | $white $IconAcces $purple $coordinates3857 $red $coordinates4326 HELLO $substringfieldsGeom $white"
done < NodeAcces.csv








echo -e '<?xml version="1.0" encoding="UTF-8"?>
<kml xmlns="http://www.opengis.net/kml/2.2" xmlns:gx="http://www.google.com/kml/ext/2.2">
  <Document>
    <Schema id="schemaAccess" name="SchemaAccess">
      <SimpleField name="Description" type="string"/>
      <SimpleField name="pdfmaps_photos" type="string">
        <displayName>Photos</displayName>
      </SimpleField>
      <SimpleField name="Commentaire" type="string"/>
      <SimpleField name="État" type="bool"/>
      <SimpleField name="Hauteur" type="string"/>
      <SimpleField name="Nombre de marches" type="string"/>
      <SimpleField name="Nombre d’échelons" type="string"/>
      <SimpleField name="Type d’accès" type="string"/>
    </Schema>
    <ExtendedData xmlns:avenza="http://www.avenza.com">
            <avenza:picklist schemaUrl="schemaAccess" avenza:field="Type d’accès">
          <avenza:picklistvalue><![CDATA[Escalier Circulaire (ECc)]]></avenza:picklistvalue>
          <avenza:picklistvalue><![CDATA[Escalier Droit (ESd)]]></avenza:picklistvalue>
          <avenza:picklistvalue><![CDATA[Puits de Service (PS)]]></avenza:picklistvalue>
          <avenza:picklistvalue><![CDATA[Lunette (Lte)]]></avenza:picklistvalue>
          <avenza:picklistvalue><![CDATA[Galerie Technique, autre (GT)]]></avenza:picklistvalue>
          <avenza:picklistvalue><![CDATA[Puits de Service à Échelons (PSé)]]></avenza:picklistvalue>
          <avenza:picklistvalue><![CDATA[Entrée en Cavage (EC)]]></avenza:picklistvalue>
          <avenza:picklistvalue><![CDATA[Raccordement aux Carrières (RC)]]></avenza:picklistvalue>
      </avenza:picklist>
    </ExtendedData>
    <Folder>
      <styleUrl>#style0</styleUrl>
      <name>Accès</name>
      <ExtendedData>
        <SchemaData schemaUrl="#schemaAccess"/>
      </ExtendedData>
' > Acces.kml

cat AccesTemp.kml >> Acces.kml
rm AccesTemp.kml
echo -e '    </Folder>
    <Style id="ESd">
      <IconStyle>
        <Icon>
           <scale>10</scale>
          <href>https://carto.sous-paris.com/sites/all/themes/cdm/css/img/h50/ESd.png</href>
        </Icon>
      </IconStyle>
    </Style>
    <Style id="PS">
      <IconStyle>
        <Icon>
           <scale>10</scale>
          <href>https://carto.sous-paris.com/sites/all/themes/cdm/css/img/h50/PS.png</href>
        </Icon>
      </IconStyle>
    </Style>
    <Style id="PSc">
      <IconStyle>
        <Icon>
           <scale>10</scale>
          <href>https://carto.sous-paris.com/sites/all/themes/cdm/css/img/h50/PSc.png</href>
        </Icon>
      </IconStyle>
    </Style>
    <Style id="PSe">
      <IconStyle>
        <Icon>
           <scale>10</scale>
          <href>https://carto.sous-paris.com/sites/all/themes/cdm/css/img/h50/PSe.png</href>
        </Icon>
      </IconStyle>
    </Style>
    <Style id="ESc">
      <IconStyle>
        <Icon>
           <scale>10</scale>
          <href>https://carto.sous-paris.com/sites/all/themes/cdm/css/img/h50/ESc.png</href>
        </Icon>
      </IconStyle>
    </Style>
    <Style id="EC">
      <IconStyle>
        <Icon>
           <scale>10</scale>
          <href>https://carto.sous-paris.com/sites/all/themes/cdm/css/img/h50/EC.png</href>
        </Icon>
      </IconStyle>
    </Style>
    <Style id="GT">
      <IconStyle>
        <Icon>
           <scale>10</scale>
          <href>https://carto.sous-paris.com/sites/all/themes/cdm/css/img/h50/GT.png</href>
        </Icon>
      </IconStyle>
    </Style>
    <Style id="Lte">
      <IconStyle>
        <Icon>
           <scale>10</scale>
          <href>https://carto.sous-paris.com/sites/all/themes/cdm/css/img/h32/lunettes.png</href>
        </Icon>
      </IconStyle>
    </Style>
    <Style id="RC">
      <IconStyle>
        <Icon>
           <scale>10</scale>
          <href>https://carto.sous-paris.com/sites/all/themes/cdm/css/img/h32/RC.png</href>
        </Icon>
      </IconStyle>
    </Style>
    <Style id="CDM">
      <IconStyle>
        <Icon>
           <scale>10</scale>
          <href>https://carto.sous-paris.com/sites/all/themes/cdm/css/img/h50/logo_white.png</href>
        </Icon>
      </IconStyle>
    </Style>
  </Document>
      <Style id="Vector">
        <LineStyle>
        <color>ff0099ff</color>
        <width>4</width>
      </LineStyle>
      <PolyStyle>
        <color>7f0099ff</color>
      </PolyStyle>
      <\style>
</kml>' >> Acces.kml
