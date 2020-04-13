# ElasticSearch

This repository contains the configuration files necessary to launch an ElasticSearch cluster.  As both the masters and the data nodes need
persistent storage, those instances are deployed as StatefulSets.  Client nodes don't require any special handling, and are launched as
standard deployments.

## Configuration

Configuration files are projected into the container using a ConfigMap.  If you need to updated the ConfigMap after changing the
configuration files, use the following command from this directory:

```
kubectl create configmap es-config --from-file=config --dry-run -o yaml | kubectl replace configmap es-config -f -
```

kubectl create configmap es-config -n devops --from-file=kibana.yml --from-file=role_mapping.yml --dry-run -o yaml | kubectl replace configmap es-config -f -


## Ingest Pipelines

We are using Ingest pipelines to process/parse the logs before storing in ElasticSearch.  See https://www.elastic.co/guide/en/elasticsearch/reference/master/ingest.html
for details.

`config/filebeat.yml` can be modified to pair logs with specific ingest pipelines

```
kubectl create configmap filebeat-config --from-file=config --dry-run -o yaml | kubectl replace configmap filebeat-config -f -
```

pipelines can be added to `./pipelines` and loaded into ElasticSearch using the `load.sh` script

## Curator

Kubernetes CronJob will run Curator once a day to delete indices older than 3 days excepts the system indexes (the indexes that start with a period).

```
kubectl create -f curator-config.yaml
kubectl create -f curator.yaml
```

We can confirm the job has been created.

```
$ kubectl get cronjobs
NAME      SCHEDULE    SUSPEND   ACTIVE    LAST-SCHEDULE
curator   1 0 * * *   False     0         <none>
```