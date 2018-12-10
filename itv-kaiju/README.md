# Container: ITV-Kaiju

Example `Dockerfile` to create a Kaiju container.

The smallest container was created from the most recent binaries provided by the Kaiju project, using a base image of python/alpine.


## Kaiju binaries
    https://github.com/bioinformatics-centre/kaiju/releases/download/v1.6.3/kaiju-1.6.3-linux-x86_64.tar.gz

## Docker images: sizing (kaiju + awscli)

    REPOSITORY  TAG                     IMAGE ID            CREATED             SIZE
    itv-kaiju   v1-alpine-awscli        68f60f9efcf2        3 minutes ago       164MB   ** smallest
    itv-kaiju   v1-ubuntu-awscli        c14f90592510        22 minutes ago      225MB
    itv-kaiju   v1-amazonlinux-awscli   6c323e73af68        44 minutes ago      355MB
    itv-kaiju   v1-centos-awscli        d05b92daa7d7        38 minutes ago      362MB
    itv-kaiju   v1-alpine               5bdfc312adef        About an hour ago   29.9MB  ** smallest
    itv-kaiju   v1-ubuntu               39dcef54b33b        About an hour ago   112MB
    itv-kaiju   v1-amazonlinux          880606df7856        About an hour ago   188MB
    itv-kaiju   v1-centos               96a9c586cfc1        About an hour ago   227MB

## Build

To build the Docker image:

    $ make vars             # check defined 'vars' to build this image
    $ make kaiju_get_bin    # download binaries
    $ make build            # build docker container
    $ make tag              # add 'v1' to latest
    $ make img              # list built images
    $ make imgs             # list all local images
    $ make sh               # test: run the container with '/bin/sh'

To send the image to a repository:

    $ make tags             # add 'v1' to remote repos
    $ make ecr              # push to 'ECR' repo (if created)
    $ make hub              # push to 'Docker Hub' repo (if exists)

To create an Amazon ECR repository:

    $ make ecr_create       # create 'repo:img' in the defined AWS account
    $ make ecr_login        # ECR login
    $ make ecr              # docker push to ECR repo


## Usage

To execute Kaiju inside the contaner a `start.kaiju.sh` script was created.

Files with a `s3://` prefix will be copied to `/tmp` dir to be processed. If
`output` has a `s3://` prefix, the final result will be uploaded to S3.

    # script: standalone
	$ NODES="s3://bucket/data/nodes.file"     \
	    NAMES="s3://bucket/data/names.file"   \
	    INPUT="s3://bucket/data/input.file"   \
	    OUTPUT="s3://bucket/data/output.file" \
	    KAIJU_ARGS="-v -x 1 -y 2"             \
	    ./start.kaiju.sh

Local files will be processed directly -- no copies involved.

    # alternative: standalone with local files
	$ export NODES="/data/nodes.file"
    $ export NAMES="/data/names.file"
    $ export INPUT="/data/input.file"
    $ export OUTPUT="/data/output.file"
    $ export KAIJU_ARGS="-v -x 1 -y 2"
	$ ./start.kaiju.sh

To be used via the Docker container:

    # docker using S3:
    $ docker run -ti \
        -e NODES="s3://bucket/data/nodes.file"   \
        -e NAMES="s3://bucket/data/names.file"   \
        -e INPUT="s3://bucket/data/input.file"   \
        -e OUTPUT="s3://bucket/data/output.file" \
        -e KAIJU_ARGS="-v -x 1 -y 2"  \
	    itv-kaiju

Finally, to be used via a Docker container, with local files, a volume must
be defined:

    # docker using local files:
    $ docker run -ti \
        -e NODES="/data/nodes.file"   \
        -e NAMES="/data/names.file"   \
        -e INPUT="/data/input.file"   \
        -e OUTPUT="/data/output.file" \
        -e KAIJU_ARGS="-v -x 1 -y 2"  \
        -v path/to/dir:/data          \
	    itv-kaiju


