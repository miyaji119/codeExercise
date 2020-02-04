#!/bin/bash

########################################
# check top:
# - 执行一次top
# - 
########################################

# top
# 发送中断信号，终止top
#kill -s SIGINT $(ps -ef | grep top | awk '{print $2}')

########################################
# functions:
#
# - 比较某个用户与其他用户内存使用情况
function compare_users_memory {
	echo "%   user list"
	echo "============"
	# collect data
	for user in `ps aux | grep -v COMMAND | awk '{print $1}' | sort -u`
	do
  		stats="$stats\n`ps aux | egrep ^$user | awk 'BEGIN{total=0}; \
    			{total += $4};END{print total,$1}'`"
	done
	# sort data numerically (largest first)
	echo -e $stats | grep -v ^$ | sort -rn | head
}

# - 分割线
function split_line {
	echo -e "=========================================="
}
########################################

# 检查是否有僵尸进程

# 查看CPU使用情况
echo -e "CPU使用情况: "
top -b -n 1 | grep Cpu
split_line
# 查看Memory使用情况
echo -e "Memory使用情况: "
top -b -n 1 | grep "KiB Mem"
split_line
# 查看Swap使用情况
echo -e "Swap使用情况: "
top -b -n 1 | grep Swap
split_line
echo -e "使用free命令查看："
free -m
split_line
# 查看使用内存量最多的5个进程的内存使用情况
echo -e "查看使用内存量最多的5个进程的内存使用情况："
ps aux | sort -rnk 4 | head -5
split_line

# 比较某个用户与其他用户内存使用情况
compare_users_memory
