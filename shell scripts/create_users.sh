#!/bin/bash

# create users

# user list was saved into a file
userFile=user_list.txt

# check whether the file existed and had content
if [[ -s $userFile ]]; then
	# if exists, backup and rename the old file
	mv $userFile $userFile-$(date +"%Y%m%d$H%M%S").bak
fi

echo "USER_NAME		PASSWORD"
echo  -e "============================"

# create users
for name in USER{1..10}
do
	# check whether the users existed
	# if existed
	if [[ id $name &>/dev/null ]]; then
		# prompt
		echo "user $name existed"
	else
		# add user
		add $name
		# set password
		PWD=$(echo $RANDOM | md5sum | cut -c1-8)
		echo $PWD | passwd --stdin &>/dev/null

		echo "$name was created successfully"
		# write into the file
		echo "$name		$PWD" >> $userFile
	fi
done