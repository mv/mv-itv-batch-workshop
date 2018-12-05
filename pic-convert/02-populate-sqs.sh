#!/bin/bash
#
# populate-sqs-image
#   - reads a list of files and inserts into SQS for processing
#

# SQS_URL="https://sqs.${AWS_REGION}.amazonaws.com/${AWS_ID}/${AWS_SQS_IMG}"
# SRC_BUCKET="${AWS_DEFAULT_PROFILE}-pic-01"
file_list="../scripts/samples-list.txt"

###
### Main
###

echo
echo "SQS_URL:   [${SQS_URL}]"
echo "SRC_BUCKET:[${SRC_BUCKET}]"
echo "file_list: [${file_list}]"
echo

for f in $( cat ${file_list} )
do

  echo "File: [${f}]"
  aws sqs send-message  \
    --queue-url ${SQS_URL}  \
    --message-body "s3://${SRC_BUCKET}/${f}" \
    --output json | grep -i messageid
  echo

done

