REGISTRY = ecr.demo.com
MODULE = demo/es
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

compose:
	docker-compose up

shell:
	docker run -it $(MODULE)/$(IMAGE) /bin/sh
