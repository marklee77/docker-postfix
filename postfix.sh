#!/bin/bash
: ${postconf_mynetworks:="$(ip route show | perl -ne 'print "$1 " if /^((?:\d{1,3}\.){3}\d{1,3}\/\d{1,2}).*?\sscope\s+link\s/')"}
export postconf_mynetworks

env | grep ^postconf_ | while IFS="=" read key value; do
    postconf -e ${key#postconf_}="$value"
done

service postfix start
