#!/bin/bash

# clean up /var

# check the usage of /var
df -h /var && du -h $(find /var -xdev -type f -size +20000k) | sort -nr

# search files which can be clean up