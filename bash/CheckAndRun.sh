
dir=$(
cd -P -- "$(dirname -- "$0")" && pwd -P
)
cd "$dir" 2>&1 &>/dev/null

# On attend que tous les fichiers soient copiés. Soit les dernier
sleep 3
for d in /tmp/parcours/parcours_*/
do
    cd "$d"
    ./parcours_export.sh
    cd -

done

cd -
