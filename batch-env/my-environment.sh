#!/bin/bash
#
# my-environment:
#   All shell environment variables, sorted.
#

dt_fmt='+%Y-%m-%dT%H:%M:%S%z'

echo
echo "BEGIN: $(date ${dt_fmt})"
echo

/usr/bin/env | /usr/bin/sort

echo
echo "END:   $(date ${dt_fmt})"
echo


