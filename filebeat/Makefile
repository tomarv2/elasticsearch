REGISTRY = dcr.xyz.com
MODULE = devlabs/es
IMAGE = filebeat
TAG = v1

.PHONY: module push-module run

all: module
push: push-module


module:
	docker build -t $(MODULE)/$(IMAGE) .
	docker tag $(MODULE)/$(IMAGE) $(MODULE)/$(IMAGE):$(TAG)

push-module:
	docker tag $(MODULE)/$(IMAGE)  $(REGISTRY)/$(MODULE)/$(IMAGE):$(TAG)
	docker push $(REGISTRY)/$(MODULE)/$(IMAGE):$(TAG)

run:
	docker run $(MODULE)/$(IMAGE)

runj:
	export DW_ZIPKIN_URL=http://zipkin:9411/ && \
	export DW_ORACLE_URL=jdbc:oracle:thin:@//devdb2.aur.test.xyz.com:1521/dev2db && \
	export DW_ORACLE_USER=bdr && \
 	export DW_ORACLE_PASS=dev1pass && \
	java -server -XX:+UseG1GC -XX:+UseStringDeduplication -jar target/autocomplete-0.1-SNAPSHOT.jar server config.yml

compose:
	docker-compose up

shell:
	docker run -it $(MODULE)/$(IMAGE) /bin/sh
