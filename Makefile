imageRepo = viglesiasce/sample-app
versionFile = VERSION
PERCENT := %
gitHash = $(shell git log -1 --pretty=format:"$(PERCENT)h")
majorVersion = $(shell awk 'BEGIN {FS="."}; {print $$1}' $(versionFile))
minorVersion = $(shell awk 'BEGIN {FS="."}; {print $$2}' $(versionFile))
subMinorVersion = $(shell awk 'BEGIN {FS="."}; {print $$3}' $(versionFile))
imageTag = v$(majorVersion).$(minorVersion)
shaTag = $(imageRepo):$(gitHash)
image = $(imageRepo):$(imageTag)

all: build test push
PHONY: all

build:
	docker build -t $(shaTag) .
	gcloud docker -- push $(shaTag)

test: build
	docker run $(shaTag) go test

push: build
	docker tag $(shaTag) $(image)
	gcloud docker -- push $(image)
	docker tag $(shaTag) $(image).$(subMinorVersion)
	gcloud docker -- push $(image).$(subMinorVersion)
