
# vim:ft=make:ts=8:sts=8:sw=8:noet:tw=80:nowrap:list

# Docker: image name
IMG=env-show

# Docker Hub repo
HUB=darthmv

# AWS ECR repo
AWS_REGION=us-east-1
AWS_ACCOUNT_ID=381098461851
ECR=${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com

# image version:  'v${version}'
version:=$(shell cat version.txt )


###
### tasks
###
.PHONY: info clean build img push hub run sh ver resetver

all: help

help:
	@echo
	@echo "Docker: [${IMG}]"
	@echo "    make vars    - Defined vars for [${IMG}]"
	@echo "    make clean   - My cleanup"
	@echo "    make build   - Run 'docker build'"
	@echo "    make img     - Run 'docker images'"
	@echo "    make push    - Run 'docker push' to ECR [${ECR}]"
	@echo "    make hub     - Run 'docker push' to docker hub [${HUB}]"
	@echo "    make run     - Run 'docker run -t -i ${IMG}'"
	@echo "    make bash    - Run 'docker run -t -i ${IMG} /bin/bash'"
	@echo "    make sh      - Run 'docker run -t -i ${IMG} /bin/sh'"
	@echo "    make ecr_create - ECR: Create repo for [${IMG}]"
	@echo "    make ecr_login  - ECR: Login"


vars:
	@echo "Container:  [${IMG}]"
	@echo "AWS ECR:    [${ECR}]"
	@echo "Docker Hub: [${HUB}]"

clean:
	@echo "TODO..."

build:
	docker build -t ${IMG} .

run:
	docker run -t -i ${IMG}

sh:
	docker run -ti -e PS1='\u@\h:\w\n\\$$ ' ${IMG} /bin/sh

bash:
	docker run -ti -e PS1='\u@\h:\w\n\\$$ ' ${IMG} /bin/bash

img:
	docker images

tag:
	docker tag  ${IMG}:latest ${IMG}:v${version}

ecr:
	docker tag  ${IMG}:v${version} ${ECR}:v${version}
	docker tag  ${IMG}:latest      ${ECR}:latest
	docker push ${ECR}:v${version}
	docker push ${ECR}:latest

hub:
	docker tag  ${IMG}:v${version} ${HUB}:v${version}
	docker tag  ${IMG}:latest      ${HUB}:latest
	docker push ${HUB}:v${version}
	docker push ${HUB}:latest

ver:
	@echo "Version: [${IMG}:${version}]"

resetver:
	@echo "Reset version to 0"
	@echo 0 > version.txt

upver:
	@echo "version: ${version}"
	echo $$(( $(version) + 1 )) > version.txt


ecr_create:
	aws ecr create-repository --repository-name ${IMG} \
	--region ${AWS_REGION}

ecr_login:
	aws ecr get-login --no-include-email --region ${AWS_REGION} | bash

