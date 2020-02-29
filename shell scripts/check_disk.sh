#!/bin/bash

########################################
# check disk:
# - 检查IO状态
#	+ 检查iowait值
########################################

########################################
# functions:
# - 检查IO状态
funciton check_io {
	
	# 检查iostat
	iostat

	iowait=$(iostat | awk NR==4'{print $4}')
}

########################################


