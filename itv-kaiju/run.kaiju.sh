#!/bin/bash
#
# run.kaiju.sh
#   - kaiju parameters as environment variables
#

# FOO=${VARIABLE:-default}  # If variable not set or null, use default.
# FOO=${VARIABLE:=default}  # If variable not set or null, set it to default.

###
### Environment variables: from command line
###
KAIJU_ARGS=${KAIJU_ARGS:="0"}
NODES=${NODES:="0"}
NAMES=${NAMES:="0"}
INPUT=${INPUT:="0"}
OUTPUT=${OUTPUT:="0"}
TMP_DIR='/tmp'

if [ "${KAIJU_ARGS}" == "0" ]
then echo "Error: KAIJU_ARGS must be defined." && exit 1
fi

if [ "${NODES}" == "0" ]
then echo "Error: KAIJU_ARGS must be defined." && exit 2
fi

if [ "${NAMES}" == "0" ]
then echo "Error: KAIJU_ARGS must be defined." && exit 3
fi

if [ "${INPUT}" == "0" ]
then echo "Error: KAIJU_ARGS must be defined." && exit 4
fi

if [ "${OUTPUT}" == "0" ]
then echo "Error: KAIJU_ARGS must be defined." && exit 5
fi

###
### Get any file: http(s)/ftp/path
###

copy_file() {

  file_src="${1}"
  file_dst="${2}"

  # substring(0,4)
  case ${file_src:0:4} in
      'http'|'ftp:')
              echo curl -s "${file_src}" > "${file_dst}"
              res="$?"
              ;;
      's3:/')
              echo aws s3 cp "${file_src}" "${file_dst}"
              res="$?"
              ;;
      *)
              if [ -f "${file_src}" ]
              then
                # local file, or mounted file: do not copy
                res="0"
              else
                echo "File: [${file_src}] is unreachale. Error."
                res="$?"
              fi
              ;;
  esac

  if [ "${res}" != "0" ]
  then
    echo
    echo "Error: Unable to get file [${FILE_LIST}]"
    echo
    exit 2
  fi
}


###
### Main
###

tmp_nodes="${TMP_DIR}/${NODES##*/}"
copy_file "${NODES}"  "${tmp_nodes}"

tmp_names="${TMP_DIR}/${NAMES##*/}"
copy_file "${NAMES}"  "${tmp_names}"

tmp_input="${TMP_DIR}/${INPUT##*/}"
copy_file "${INPUT}"  "${tmp_input}"

tmp_output="${TMP_DIR}/${OUTPUT##*/}"

set -e

# echo "kaiju args: [kaiju ${KAIJU_ARGS}]"
echo
echo "== Kaiju: Begin: $( date '+%Y-%m-%dT%H:%M:%S%z' )"

echo kaiju -t "${tmp_nodes}" -n "${tmp_names}" -i "${tmp_input}" -o "${tmp_output}" "${KAIJU_ARGS}"
echo kaiju \
   -t "${tmp_nodes}"  \
   -n "${tmp_names}"  \
   -i "${tmp_input}"  \
   -o "${tmp_output}" \
   "${KAIJU_ARGS}"

echo "== Kaiju: End: $( date '+%Y-%m-%dT%H:%M:%S%z' )"
echo

###
### Results: copy if output must go back to S3
###

if [ "${OUTPUT:0:2}" == "s3" ]
then
  echo "-- S3 copy: Begin: $( date '+%Y-%m-%dT%H:%M:%S%z' )"
  echo aws s3 cp "${tmp_output}" "${OUTPUT}"
  echo "-- S3 copy: End: $( date '+%Y-%m-%dT%H:%M:%S%z' )"
else
  echo "-- S3 copy: not needed."
fi

