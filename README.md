## Docker Image
This is a thin wrapper around the official Filebeat container as we need to run the container as root to be able to access the host path volumes.

***
## ElasticHQ
Managing ES cluster: https://hub.docker.com/r/elastichq/elasticsearch-hq

***
## Troubleshooting ES
To recover kibana from index issue, restart kibana pod after running below command:
```
curl -s http://es.demo.com/.kibana/_recovery?pretty
```

***
**Get cluster health**

```
curl -GET http://es.demo.com/_cluster/health?pretty
```

***
**Find unassigned shards**
```
curl -s 'http://es.demo.com/_cat/shards' | fgrep UNASSIGNED 
```

***
**List nodes info**
```
curl -XGET 'http://192.168.64.2:30765/_nodes?pretty'
curl -XGET 'http://es.demo.com/_nodes?pretty'
------------------------  ------------------------  ------------------------  ------------------------

curl -XGET 'http://es.demo.com/_cat/nodes?v'
ip            heap.percent ram.percent cpu load_1m load_5m load_15m node.role master name
172.31.64.18            45          99  35   10.03   10.51     7.47 d         -      es-data-2
172.31.240.26           45          69   2    0.34    0.21     0.23 m         -      es-master-0
172.31.192.34           60          98  32    4.75    5.66     3.75 i         -      es-client-467693306-dzs3m
172.31.48.11            53          98  26    8.53    9.05     6.92 d         -      es-data-1
172.31.64.24            49          99  36   10.03   10.51     7.47 i         -      es-client-467693306-6vc0b
172.31.192.11           71          98  32    4.75    5.66     3.75 d         -      es-data-0
172.31.192.29           53          98  30    4.75    5.66     3.75 m         -      es-master-2
172.31.192.16           43          98  32    4.75    5.66     3.75 m         *      es-master-1
------------------------  ------------------------  ------------------------  ------------------------
```
***
```
NODE="X01234567890"
IFS=$'\n'
for line in $(curl -s 'http://es.demo.com/_cat/shards' | fgrep UNASSIGNED); do
  INDEX=$(echo $line | (awk '{print $1}'))
  SHARD=$(echo $line | (awk '{print $2}'))

  curl -XPOST 'http://es.demo.com/_cluster/reroute' -d '{
      "commands" : [
          {
            "allocate_stale_primary" : {
                  "index" : "kubernetes-stdout-logs-2017.10.31", "shard" : 2,
                  "node" : "X01234567890",
                  "accept_data_loss" : "true"
            }
          }
      ]
  }'
```
***
**Node info in detail**
```
curl -XGET 'http://es.demo.com/_nodes?pretty'
```

***
**Move shard to a new node**
```
curl -XPOST 'http://es.demo.com/_cluster/reroute' -d '{
    "commands" : [
        {
          "allocate_stale_primary" : {
                "index" : "kubernetes-stdout-logs-2017.10.31", "shard" : 2,
                "node" : "X01234567890",
                "accept_data_loss" : "true"
          }
        }
    ]
}'
```
***

**Delete unassigned indexes**
```
curl -XDELETE 'http://es.demo.com/kubernetes-stdout-logs-2017.10.28'

for i in `curl -s 'http://es.demo.com/_cat/shards' | fgrep UNASSIGNED |cut -f 1 -d' '|uniq`;do curl -XDELETE http://es.demo.com/$i; done
```

***
```
curl -XPUT  -H'Content-Type:application/json' 'es.demo.com/_cluster/settings' -d'
{ "transient":
  { "cluster.routing.allocation.enable" : "all"
  }
}'

http://es.demo.com/_cat/allocation?v
```

**Revert read only index**
```
curl -XPUT -H "Content-Type: application/json" http://es.demo.com/.monitoring-*/_settings -d '{"index.blocks.read_only_allow_delete": null}'
```
***
```
PUT _settings { "index": { "blocks": { "read_only_allow_delete": "false" } } }
```
***
```
PUT your_index_name/_settings { "index": { "blocks": { "read_only_allow_delete": "false" } } }
```

***
```
PUT .kibana/_settings
{
"index": {
"blocks": {
"read_only_allow_delete": "false"
}
}
}
```

*** 
```
curl  -H 'Content-Type:application/json' -XPUT es.demo.com/_cluster/settings -d '{
    "transient" : {
        "cluster.routing.allocation.disk.threshold_enabled" : false
    }
}'
```
***
**Reallocate shards**
```
curl -H 'Content-Type:application/json' -XPUT 'es.demo.com/_cluster/settings' -d '
{ "transient":
    { "cluster.routing.allocation.enable" : "all" 
    }
}'
```
***

```
GET /_cluster/allocation/explain?pretty
```
***
```
GET _search
{
   "query": {
     "match_all": {}
   }
}
```
***

```
GET .kibana/index-pattern/kubernetes-stderr-logs-*
```
***

```
GET .kibana/index-pattern/_search
```
***

```
GET _search
{
  "query": {
    "match": "user-agent"
  }
}
```
***

```
GET _search
{
 "query": {
   "multi_match": {
     "query": "spinnaker",
     "fields": ["namespace"]
   }
 }
}
```
***
**Info about indices**
```GET _cat/indices?v```

***
**Check how is master**

```GET _cat/master?v```
***
**List all available options**

```GET _cat/```
***
**List plugins**

```GET _cat/plugins```
***

**Bulk import data**
```
curl -s -XPOST localhost:9200/<index_name>/_<end_point> --data-binary @filename.json
```

**Delete .watches**
```
GET _cat/indices/.watches?pretty

curl -XPUT http://es.demo.com/_xpack/license?acknowledge=true -H "Content-Type: application/json" -d @demo-123456-v5.json
{"acknowledged":true,"license_status":"valid"}
```

```
\- \[\] \- - \[%{HTTPDATE:timestamp}\] \\"(?:%{WORD:verb} %{NOTSPACE:request}(?: HTTP/%{NUMBER:httpversion})?|-)
```
