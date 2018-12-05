#!/bin/bash
#
# populate-sqs-image
#   - reads a list of files and inserts into SQS for processing
#

# SQS_URL="https://sqs.${AWS_REGION}.amazonaws.com/${AWS_ID}/${AWS_SQS_IMG}"
# SRC_BUCKET="${AWS_DEFAULT_PROFILE}-pic-01"
file_list="../scripts/profiles-list.txt"

###
### Main
###

set -e

echo
echo "SQS_URL:   [${SQS_URL}]"
echo "SRC_BUCKET:[${SRC_BUCKET}]"
echo "file_list: [${file_list}]"
echo

# ensure using sqs queue even from a different region
sqs_region=$( echo $SQS_URL | awk -F. '{print $2}' )

for f in $( cat ${file_list} )
do

  echo "File: [${f}]"
  aws sqs send-message      \
    --queue-url ${SQS_URL}  \
    --message-body "${f}"   \
    --region ${sqs_region}  \
    --output json | grep -i messageid
  echo

#
#   --message-body "s3://${SRC_BUCKET}/${f}" \

done

