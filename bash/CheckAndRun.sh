
dir=$(
cd -P -- "$(dirname -- "$0")" && pwd -P
)
cd "$dir" 2>&1 &>/dev/null

# On attend que tous les fichiers soient bien copiés. Soit les dernier
for d in /tmp/parcours/parcours_*/
do

while [ ! -f "$d"/NID ]
do
sleep 10
done

NID=$(cat "$d"/NID)
echo $NID
sudo cp -R "$d" "$NID"_TMP
sudo rm -R "$d"
done


sudo chmod -R 777 "$NID"_TMP
cd "$NID"_TMP
#chown -R www-data:www-data "$d"
sudo ./parcours_export.sh
cd -
sudo rm -R "$NID"_TMP
