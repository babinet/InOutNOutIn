
#  annees.txt est la copie du html des taxonomies
cat annees.txt | tr -d '\n' | sed 's/taxonomy\/term\//\
/'g | awk -F'<\/a>' '{print $1}' | awk '!/destination/' | awk -F'"' '{print $1, $4}' | sed 's/ >/|/g' > Annees_tid.txt

# INSPECTEURS
while read thisline
do
tid=$(echo "$thisline" | awk -F'|' '{print $1}')
Annee=$(echo "$thisline" |awk -F'|' '{print $2}')
#echo $inspecteurs
#echo $tid
echo "if [[ \"\$InscriptionYear\" == $tid ]]; then Annee=\$(echo -e \"$Annee\"); echo -e \"\${white}---> Année : \${orange}\$Annee\"; fi"
done < Annees_tid.txt


# Type d'inscriptoion Type_dinscriptoion_Tmp.txt est la copie du html des taxonomies
#  annees.txt est la copie du html des taxonomies
cat Type_dinscriptoion_Tmp.txt | tr -d '\n' | sed 's/taxonomy\/term\//\
/'g | awk -F'<\/a>' '{print $1}' | awk '!/destination/' | awk -F'"' '{print $1, $4}' | sed 's/ >/|/g' > Type_dinscriptoion.txt

while read thisline2
do
tid=$(echo "$thisline2" | awk -F'|' '{print $1}')
TypeDInscription=$(echo "$thisline2" |awk -F'|' '{print $2}')
echo "if [[ \"\$TypeDInscription\" == $tid ]]; then TypeDInscriptionABC=\$(echo -e \"$TypeDInscription\"); echo -e \"\${white}---> Type D'inscriptions : \${orange}\$TypeDInscriptionABC\"; fi"
done < Type_dinscriptoion.txt
