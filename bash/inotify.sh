#!/bin/sh
mkdir -p  /tmp/parcours/
cp -pa /CheckAndRun.sh /tmp/parcours/
chmod -R 777 /tmp/parcours/
chown -R www-data:www-data  /tmp/parcours/

while true; do
  inotifywait -e create /tmp/parcours/
  # Running pattern
/tmp/parcours/CheckAndRun.sh
done
