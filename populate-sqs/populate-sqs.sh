#!/bin/bash
#
# populate-sqs.sh
#   - reads a list of files and inserts into SQS for processing
#

# FOO=${VARIABLE:-default}  # If variable not set or null, use default.
# FOO=${VARIABLE:=default}  # If variable not set or null, set it to default.
# SQS_URL="https://sqs.${AWS_REGION}.amazonaws.com/${AWS_ID}/${SQS_NAME}"

###
### Environment variables: from command line
###
SQS_URL=${SQS_URL:=""}
FILE_LIST=${FILE_LIST:="../scripts/samples-list.txt"}
JOB_NODES=${JOB_NODES:=1}
JOB_INDEX=${AWS_BATCH_JOB_ARRAY_INDEX:=0}
TMP_DIR='/tmp'

[ -z "${SQS_URL}" ] && {
  echo
  echo "Error: SQS_URL must be defined."
  echo
  exit 1
}

# ensure using sqs queue even from a different region
sqs_region=$( echo $SQS_URL | awk -F. '{print $2}' )


###
### Get file list
###
file_dest="${TMP_DIR}/${FILE_LIST##*/}"     # extract filename
file_prefix=${FILE_LIST:0:4}                # substring(0,4)

case ${file_prefix} in
  'http'|'ftp:')
                  curl -s "${FILE_LIST}" > "${file_dest}"
                  res="$?"
                  ;;
         's3:/')
                  aws s3 cp "${FILE_LIST}" "${file_dest}"
                  res="$?"
                  ;;
              *)
                  cp "${FILE_LIST}" "${file_dest}"
                  res="$?"
                  ;;
esac

[ "${res}" != "0" ] && {
  echo
  echo "Error: Unable to get file [${FILE_LIST}]"
  echo
  exit 2
}

set -e

###
### Partition the file
###
nodes=${JOB_NODES}
my_index=${JOB_INDEX}

lines_total=$( wc -l ${file_dest} | awk '{print $1}' )
lines_per_node=$(( ${lines_total}/${nodes} ))

n_start=$(( ${lines_per_node} * ${my_index} + 1 ))
n_final=$(( ${lines_per_node} * ${my_index} + ${lines_per_node} ))

echo
echo "nodes:          [${nodes}]"
echo "my_index:       [${my_index}]"
echo "file_dest:      [${file_dest}]"
echo "lines_total:    [${lines_total}]"
echo "lines_per_node: [${lines_per_node}]"
echo

###
### lines_per_node: fix any round erros of integer division
###
### file: 100 lines, nodes=4
###   INDEX     begin    end  extra
###      0          1     25     75
###      1         26     50     50
###      2         51     75     25
###      3         76    100      0   # no extra lines
###
### file: 102 lines, nodes=4
###   INDEX     begin    end  extra
###      0          1     25     77
###      1         26     50     52
###      2         51     75     27
###      3         76    100      2   # extra lines

extra_lines=$(( ${lines_total} - ${n_final} ))

if [ ${extra_lines} -gt 0 ] \
&& [ ${extra_lines} -lt ${lines_per_node} ]
then
  n_final=${lines_total} # include to the end of file
  msg="${extra_lines}"
else
  msg="no extra lines"
fi

echo "n_start:  [${n_start}]"
echo "n_final:  [${n_final}]"
echo "extra:    [${msg}]"
echo


###
### Main
###

kount=${n_start}
echo
echo "== SQS"

for f in $( sed -n "${n_start},${n_final} p" ${file_dest} )
do

  echo "-- File: ${kount} [${f}]"
  aws sqs send-message      \
    --queue-url ${SQS_URL}  \
    --message-body "${f}"   \
    --region ${sqs_region}  \
    --output json | grep -v MD5OfMessageBody
  echo
  kount=$(( ${kount} + 1 ))

done

