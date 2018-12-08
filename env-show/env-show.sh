#!/bin/sh
#
# my-environment:
#   All shell environment variables, sorted.
#

# format: iso-8601
dt_fmt='+%Y-%m-%dT%H:%M:%S%z'

echo
echo "BEGIN: $(date ${dt_fmt})"
echo

env | sort

echo
echo "END: $(date ${dt_fmt})"
echo

