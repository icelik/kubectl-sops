default: docker_build
include .env

VARS:=$(shell sed -ne 's/ *\#.*$$//; /./ s/=.*$$// p' .env )
$(foreach v,$(VARS),$(eval $(shell echo export $(v)="$($(v))")))
DOCKER_IMAGE ?= icelik/kubectl-sops
DOCKER_TAG ?= `git rev-parse --abbrev-ref HEAD`

docker_build:
	@docker buildx build \
	  --build-arg KUBE_VERSION=$(KUBE_VERSION) \
	  --build-arg SOPS_VERSION=${SOPS_VERSION} \
	  -t $(DOCKER_IMAGE):$(DOCKER_TAG) .

docker_push:
	docker push $(DOCKER_IMAGE):$(DOCKER_TAG)
