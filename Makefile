default: docker_build

DOCKER_IMAGE ?= quay.io/lachie83/jnlp-slave
BUILD_NUMBER ?= `git rev-parse --short HEAD`
VCS_REF ?= `git rev-parse --short HEAD`

.PHONY: docker_build
docker_build:
	@docker build \
	  --build-arg VCS_REF=$(VCS_REF) \
	  --build-arg BUILD_DATE=`date -u +"%Y-%m-%dT%H:%M:%SZ"` \
	  -t $(DOCKER_IMAGE):$(BUILD_NUMBER) .

.PHONY: docker_push
docker_push:
	# Push to DockerHub
	docker tag $(DOCKER_IMAGE):$(BUILD_NUMBER) $(DOCKER_IMAGE):latest
	docker push $(DOCKER_IMAGE):$(BUILD_NUMBER)
	docker push $(DOCKER_IMAGE):latest

.PHONY: docker_run
test:
	docker run $(DOCKER_IMAGE):$(BUILD_NUMBER) helm version --client

.PHONY: all
all: docker_build docker_push
