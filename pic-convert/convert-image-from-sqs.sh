#!/bin/bash
#
# convert-image-from-sqs.sh
#   - get one item from sqs
#   - use item to get image from source bucket
#   - convert to pdf
#   - save pdf to dest bucket
#   - delete message
#

###
### external
###

[ -z "${SQS_URL}"   ] && {
  echo "env SQS_URL not defined."
  exit 1
}

[ -z "${SRC_BUCKET}" ] && {
  echo "env SRC_BUCKET not defined."
  exit 1
}

[ -z "${DST_BUCKET}" ] && {
  echo "env DST_BUCKET not defined."
  exit 1
}

echo
echo "== Begin: $( date )"
echo
echo "SQS_URL   : ${SQS_URL}"
echo "SRC_BUCKET: ${SRC_BUCKET}"
echo "DST_BUCKET: ${DST_BUCKET}"
echo

#set -x

###
### local
###
tmp_dir="/tmp"
sqs_msg="${tmp_dir}/sqs-message.json"
sqs_rec=""
img_loc=""
img_file=""
pdf_file=""

sqs_region=$( echo $SQS_URL | awk -F. '{print $2}' )

get_item_from_sqs() {
  aws sqs receive-message   \
    --queue-url ${SQS_URL}  \
    --output json           \
    --region ${sqs_region}  \
    > ${sqs_msg}

  sqs_rec=$(cat ${sqs_msg} | jq '.Messages[0].ReceiptHandle' | sed -e 's/"//g')
  img_loc=$(cat ${sqs_msg} | jq '.Messages[0].Body'          | sed -e 's/"//g')

  img_file=${img_loc##*/}     # extract filename
  pdf_file=${img_file%.*}.pdf # new suffix
}

del_item_from_sqs() {
  aws sqs delete-message    \
    --queue-url ${SQS_URL}  \
    --region ${sqs_region}  \
    --receipt-handle ${sqs_rec}
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


  # Get image
  set -x
  aws s3 cp "s3://${SRC_BUCKET}/${img_loc}" \
            "${tmp_dir}/${img_file}" || \
  aws s3 cp "${img_loc}" \
            "${tmp_dir}/${img_file}"
  convert   "${tmp_dir}/${img_file}" "${tmp_dir}/${pdf_file}"

  # Put image
  aws s3 cp "${tmp_dir}/${pdf_file}" "s3://${DST_BUCKET}/${pdf_file}"
  set +x


  # Cleanup
  del_item_from_sqs

done

echo
echo "== End: $( date )"
echo

