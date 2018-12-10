#!/bin/bash
#
# run.${x}.sh
#   - kaiju with parameters
#   - idea: different 'run' sessions have different data files
#
#   run.marcus.sh -- files from user 'marcus'
#   run.jose.sh   -- files from user 'jose'
#

###
### Environment variables: from command line
###
KAIJU_ARGS="-v"
NODES="/data/nodes.file"
NAMES="/data/names.file"
INPUT="/data/input.file"
OUTPUT="/data/output.file"

echo
echo "== Kaiju: Begin: $( date '+%Y-%m-%dT%H:%M:%S%z' )"

kaiju -t "${NODES}" -n "${NAMES}" -o "${OUTPUT}" "${KAIJU_ARGS}" \
      -i "${INPUT}"

echo "== Kaiju: End: $( date '+%Y-%m-%dT%H:%M:%S%z' )"
echo

