# vim:ft=make:ts=8:sts=8:sw=8:noet:tw=80:nowrap:list

# Docker: image name
IMG=img-convert-to-pdf

# DockerHub repo
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
	@echo "Docker: [${IMG}]"
	@echo
	@echo "    make vars  - Defined vars for [${IMG}]"
	@echo
	@echo "    make build - Run 'docker build'"
	@echo "    make img   - Run 'docker images' for [${IMG}]"
	@echo "    make imgs  - Run 'docker images' for all"
	@echo "    make tag   - Run 'docker tag' latest to [v${version}]"
	@echo "    make tags  - Run 'docker tag' latest to ECR and DockerHub"
	@echo
	@echo "    make run   - Run 'docker run -t -i ${IMG}'"
	@echo "    make sh    - Run 'docker run -t -i ${IMG} /bin/sh'"
	@echo "    make bash  - Run 'docker run -t -i ${IMG} /bin/bash'"
	@echo
	@echo "    make ecr   - Run 'docker push' to ECR: [${ECR}:${IMG}]"
	@echo "    make hub   - Run 'docker push' to DockerHub: [${HUB}/${IMG}]"
	@echo
	@echo "    make clean_imgs - Cleanup: remove local [${IMG}] images"
	@echo "    make clean_tags - Cleanup: remove REMOTE tags"
	@echo "    make clean      - Cleanup: remove local images and REMOTE tags"
	@echo
	@echo "    make ecr_create - ECR: Create repo for [${IMG}]"
	@echo "    make ecr_login  - ECR: Login"
	@echo
	@echo "    make ver      - Current version: [${IMG}:v${version}]"
	@echo "    make upver    - Current version + 1"
	@echo "    make resetver - Reset version to [v0]"
	@echo


vars:
	@echo "Container:  [${IMG}]"
	@echo "AWS ECR:    [${ECR}]"
	@echo "Docker Hub: [${HUB}]"

build:
	docker build -t ${IMG} .

run:
	docker run -t -i ${IMG}

sh:
	docker run -ti -e PS1='\u@\h:\w\n\\$$ ' ${IMG} /bin/sh

bash:
	docker run -ti -e PS1='\u@\h:\w\n\\$$ ' ${IMG} /bin/bash

img:
	docker images | egrep "REPOSITORY|${IMG}"

imgs:
	docker images

tag:
	docker tag  ${IMG}:latest   ${IMG}:v${version}

tags:
	docker tag  ${IMG}:latest   ${IMG}:v${version}
	@echo
	docker tag  ${IMG}:v${version} ${ECR}/${IMG}:v${version}
	docker tag  ${IMG}:v${version} ${HUB}/${IMG}:v${version}
	docker tag  ${IMG}:latest ${ECR}/${IMG}:latest
	docker tag  ${IMG}:latest ${HUB}/${IMG}:latest

ecr:
	docker push ${ECR}/${IMG}:v${version}
	docker push ${ECR}/${IMG}:latest

hub:
	docker push ${HUB}/${IMG}:v${version}
	docker push ${HUB}/${IMG}:latest

clean_tags:
	docker images --format "{{.ID}} {{.Repository}}:{{.Tag}}" \
	    | egrep "${HUB}|${ECR}" \
	    | cut -f2 -d ' '        \
	    | sort                  \
	    | xargs docker rmi

clean_imgs:
	docker images --format "{{.ID}} {{.Repository}}:{{.Tag}}" \
	    | egrep "${IMG}"        \
	    | cut -f2 -d ' '        \
	    | sort                  \
	    | xargs docker rmi -f

clean:  clean_tags clean_imgs


ver:
	@echo "Current version: [${IMG}:v${version}]"

resetver:
	@echo "Version: v0. Done."
	@echo 0 > version.txt

upver:
	@echo "UP Version... "
	@echo $$(( $(version) + 1 )) > version.txt
	@cat version.txt


ecr_create:
	aws ecr create-repository --repository-name ${IMG} \
	--region ${AWS_REGION}

ecr_login:
	aws ecr get-login --no-include-email --region ${AWS_REGION} | bash

