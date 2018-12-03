#!/bin/bash
#
# convert-image-from-sqs.sh
#   - get one item from sqs
#   - get image from source bucket
#   - convert to pdf
#   - save pdf to dest bucket
#   - delete message
#

SQS_IMAGE=""
SRC_BUCKET=""
DST_BUCKET=""
TMP_DIR="/tmp"

sqs_rec=""
img_loc=""
img_file=""
pdf_file=""

sqs_msg="${TMP_DIR}/sqs-message.json"

get_item_from_sqs() {
  aws sqs receive-message \
    --queue-url ${SQS}    \
    --output json         \
    > ${sqs_msg}

  sqs_rec=$(cat ${sqs_msg} | jq '.Messages[0].ReceiptHandle' | sed -e 's/"//g')
  img_loc=$(cat ${sqs_msg} | jq '.Messages[0].Body'          | sed -e 's/"//g')

  img_file=${img_loc##*/}     # extract filename
  pdf_file=${img_file%.*}.pdf # new suffix
}

del_item_from_sqs() {
  aws sqs delete-message  \
    --queue-url ${SQS}    \
    --receipt-handle ${sqs_rec}
}

get_image() {
  echo aws s3 cp

}

###
### Main
###

while true
do

  # Find image to be processed
  get_item_from_sqs

  if [ -z "${sqs_rec}" ]
  then
    echo
    echo "SQS: No more itens."
    echo
    exit 0
  fi

  echo
  echo "Receipt:  [${sqs_rec:0:10}]"  # string 0:10
  echo "img_loc:  [${img_loc}]"
  echo "img_file: [${img_file}]"
  echo "pdf_file: [${pdf_file}]"
  echo


  # Process
  echo aws s3 cp ${img} ${TMP_DIR}/${img_file}
  echo convert ${TMP_DIR}/${img_file} ${TMP_DIR}/${pdf_file}
  echo aws s3 cp ${TMP_DIR}/${pdf_file} s3://${DST_BUCKET}/pdf/


  # Cleanup
  del_item_from_sqs

done


