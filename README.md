# FileBeat Log Shipper

There is a DaemonSet definition that contains the FileBeat log shipper, which mounts the hostPath volume where Kubernetes/Docker is sending
all of the container logs.  This seems like a better approach for shipping Kubernetes container logs than using an instance of FileBeat on the host.
We probably will still need to deploy FileBeat on the hosts at some point, but they would ship system/non-container logs.

## Docker Image
This is a thin wrapper around the official Filebeat container as we need to run the container as root to be able to access the host path volumes.

## ElasticHQ
Managing ES cluster: https://hub.docker.com/r/elastichq/elasticsearch-hq