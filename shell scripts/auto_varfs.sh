#!/bin/bash

# clean up /var

# check the usage of /var
df -h /var && du -h $( find /var -xdev -type f -size +10000k ) | sort -nr

# search files which can be clean up
# the list of files which can be cleaned up
search_list=('/var/log/message','/var/log/LDAP/')