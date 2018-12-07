# vim:ft=make:ts=8:sts=8:sw=8:noet:tw=80:wrap:list

PROJ=show-env
ECR=381098461851.dkr.ecr.us-east-1.amazonaws.com/${PROJ}
HUB=darthmv/${PROJ}

version:=$(shell cat version.txt )

.PHONY: info clean build img push hub run sh ver resetver

all:
	@echo "Project: [${PROJ}]"
	@echo "    make info    - My info for [${PROJ}]"
	@echo "    make clean   - My cleanup"
	@echo "    make build   - Run 'docker build'"
	@echo "    make img     - Run 'docker images'"
	@echo "    make push    - Run 'docker push' to repo [{REPO}]"
	@echo "    make hub     - Run 'docker push' to docker hub [${HUB}]"
	@echo "    make run     - Run 'docker run -t -i ${PROJ}'"
	@echo "    make sh      - Run 'docker run -t -i ${PROJ} /bin/sh'"

info:
	@echo "Project:    [${PROJ}]"
	@echo "My Repo:    [${REPO}]"
	@echo "Dcoker Hub: [${HUB}]"

clean:
	@echo "TODO..."

build:
	docker build -t ${PROJ} .

run:
	docker run -t -i ${PROJ}

sh:
	docker run -ti -e PS1='\u@\h:\w\n\\$$ ' ${PROJ} . /bin/sh

bash:
	docker run -ti -e PS1='\u@\h:\w\n\\$$ ' ${PROJ} . /bin/bash

img:
	docker images

tag:
	docker tag  ${PROJ}:latest ${PROJ}:v${version}

ecr:
	docker tag  ${PROJ}:v${version} ${ECR}:v${version}
	docker tag  ${PROJ}:latest      ${ECR}:latest
	docker push ${ECR}:v${version}
	docker push ${ECR}:latest

hub:
	docker tag  ${PROJ}:v${version} ${HUB}:v${version}
	docker tag  ${PROJ}:latest      ${HUB}:latest
	docker push ${HUB}:v${version}
	docker push ${HUB}:latest

ver:
	@echo "Version: ${PROJ}:${version}"

resetver:
	@echo "Reset version to 0" ; echo 0 > version.txt


