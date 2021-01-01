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
coordinates=$(echo -e "$substringfieldsGeom" | awk -F'coordinates\": ' '{print $2}' | awk -F', \"' '{print $1}' | tr -d '[]' )
echo -e "---> \$coordinates ---- ------ ------ ------ ------> "$coordinates""
TypeGeom=$(echo -e "$substringfieldsGeom" | awk -F'"srid": ' '{print $2}' | awk -F'\"type\": \"' '{print $2}' | awk -F'\"' '{print $1}')
echo -e "---> \$TypeGeom  ------ ------ ------ ------ ------> "$TypeGeom""

if [ "$SRSID" == "3857" ]
then
echo "$orange---> EPSG:3857 WGS 84 PSEUDO MERCATOR (meters)"
elif [ "$SRSID" == "4326" ]
then
echo "$orange---> EPSG:4326 WGS 84 PSEUDO MERCATOR (degrees)"
fi

#"coordinates": [259355.15036348, 6246907.9571004], "crs": {"properties": {"name": "EPSG3857"}, "type": "name"}, "meta": {"srid": 3857}, "type": "Point"}

echo -e "${orange}$NodeTitle|${white} SUBSTRING $substringfields|$purple HELLO $substringfieldsGeom $white"
done < NodeAcces.csv

