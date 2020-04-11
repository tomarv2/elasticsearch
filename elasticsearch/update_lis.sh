#!/usr/bin/env bash

curl -XPUT -u elastic 'http://es.test.xyz.com:80/_xpack/license?acknowledge=true' -H "Content-Type: application/json" -d @lis.json