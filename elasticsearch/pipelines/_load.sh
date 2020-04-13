#!/bin/sh

for f in *log
do
	echo "Creating pipeline in file - $f"

FILENAME=$f
curl -X PUT -H 'Content-Type: application/json' -d @$FILENAME http://es.demo.com/_ingest/pipeline/$FILENAME
#curl -X PUT -d @$FILENAME http://es.demo.com/_ingest/pipeline/$PIPELINE

done
