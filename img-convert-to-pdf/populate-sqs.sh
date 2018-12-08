#!/bin/bash
#
# populate-sqs.sh
#   - reads a list of files and inserts into SQS for processing
#

# SQS_URL="https://sqs.${AWS_REGION}.amazonaws.com/${AWS_ID}/${AWS_SQS_IMG}"
# SRC_BUCKET="${AWS_DEFAULT_PROFILE}-pic-01"

AWS_BATCH_JOB_NUM_NODES=4
nodes=4

AWS_BATCH_JOB_ARRAY_INDEX=2
my_index=$(( ${AWS_BATCH_JOB_ARRAY_INDEX} + 0 ))

file_list="../scripts/samples-list.txt"
lines_total=$( wc -l ${file_list} | awk '{print $1}' )
lines_per_node=$(( ${lines_total}/${nodes} ))

### lines_per_node
###   INDEX     begin    end
###      0          1     25
###      1         26     50
###      2         51     75
###      3         76    100
###      -          -    102  # extra lines
###

nstart=$(( ${lines_per_node} * ${my_index} + 1 ))
nfinal=$(( ${lines_per_node} * ${my_index} + ${lines_per_node} ))

echo
echo "nodes:          [${nodes}]"
echo "file_list:      [${file_list}]"
echo "lines_total:    [${lines_total}]"
echo "lines_per_node: [${lines_per_node}]"
echo
echo "my_index: [${my_index}]"
echo "nstart:   [${nstart}]"
echo "nfinal:   [${nfinal}]"
echo

# lines_per_node: fix any round erros of integer division
extra_lines=$(( ${lines_total} - ${nfinal} ))

if [ ${extra_lines} -gt 0 ] \
&& [ ${extra_lines} -lt ${lines_per_node} ]
then
  nfinal=${lines_total} # go to the end of file
  echo "extra:    [${extra_lines}]"
fi


###
### Main
###

for f in $( sed -n "${nstart},${nfinal} p" )
do

  echo "File: [${f}]"
  aws sqs send-message      \
    --queue-url ${SQS_URL}  \
    --message-body "${f}"   \
    --region ${sqs_region}  \
    --output json | grep -i messageid
  echo

done

