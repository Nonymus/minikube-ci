NAME?=minikubeci
TAG?=latest
REPOSITORY?=nonymus/$(NAME)

all: build
build:
	docker build -t $(REPOSITORY):$(TAG) .

run: build
	docker run --privileged --rm -it $(REPOSITORY):$(TAG)

.PHONY: all build run
