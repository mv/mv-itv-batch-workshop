#!/bin/bash
#
# create-sqs
#

# SQS_URL="https://sqs.${AWS_REGION}.amazonaws.com/${AWS_ID}/${AWS_SQS_IMG}"
# SRC_BUCKET="${AWS_DEFAULT_PROFILE}-pic-01"

###
### Main
###

[ -z "$1" ] && {

  echo
  echo "Usage: $0 <name>"
  echo
  exit 1

}

sqs_name="sqs-image-${1}"

echo
echo "SQS Name: [${sqs_name}]"
echo

aws sqs create-queue --queue-name ${sqs_name}

