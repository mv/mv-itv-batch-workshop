#!/bin/sh
#
# my-environment:
#   All shell environment variables, sorted.
#
# ferreira.mv@gmail.com
# 2018-12

# format: iso-8601
dt_fmt='+%Y-%m-%dT%H:%M:%S%z'

echo
echo "BEGIN: $(date ${dt_fmt})"
echo

env | sort

echo
echo "END: $(date ${dt_fmt})"
echo

