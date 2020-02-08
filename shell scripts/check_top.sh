#!/bin/bash

########################################
# check top:
# - 检查top的执行结果
# - 杀掉僵尸进程的父进程
# - 检查CPU使用情况，分析
#	+ 找到消耗CPU最多的10个进程
#   + 使用率分为：us（用户）、sy（系统）、id（空闲）、wa（IO等待）、ni（通过nice命令改变过优先级）、hi（硬中断）、si（软中断）、st（虚拟机）
#   + 如果wa很高，就需要看一下磁盘I/O
#   + 如果wa很低，id很高，但系统还是很慢，那就要查一下网络IO或者远程服务器的回应是不是很慢，或者查一下上下文切换和锁，看看是否存在大量的锁争用和等待的情况
# - 检查Memory使用情况
#	+ 找到消耗内存最多的前10个进程
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

# - 检查并清除僵尸进程
function check_clean_zombie {
	
	# 检查是否有僵尸进程
	echo -e "僵尸进程个数: "
	top -b -n 1 | grep Tasks | awk -F ',' '{print $5}'
	
	# 僵尸进程个数
	local num=$(ps -ef | grep defunct | grep -v grep | wc -l)

	# 如果有僵尸进程就进行清理
	if [[ $num -gt 0 ]]; then
		# 找到僵尸进程的PPID
		# ps -ef | grep defunct | grep -v grep | awk '{print $3}'
		# 杀掉僵尸进程的父进程
		ps -ef | grep defunct | grep -v grep | awk '{print $3}' | xargs kill -9
	fi
}

# - 检查CPU使用情况
function check_cpu_situation {
	
	# 查看CPU使用情况
	echo -e "CPU使用情况: "
	local total=$(top -b -n 1 | grep Cpu)
	
	split_line	# 分割线

	echo "用户空间占CPU的百分比: $( echo $total | awk '{print $2}' )"
	echo "内核空间占CPU的百分比： $( echo $total | awk -F ',' '{print $2}' )"
	echo "空闲CPU百分比： $( echo $total | awk -F ',' '{print $4}' )"
	echo "等待输入输出的CPU时间百分比： $( echo $total | awk -F ',' '{print $5}' )"

	# 找到消耗CPU最多的前10个进程
	echo "消耗CPU最多的前10个进程："
	ps -eo pcpu,pid,user,args | sort -k 1 -r | head -10

	# split_line
}

# - 检查Memory使用情况
function check_memory_situation {
	# 查看Memory使用情况
	echo -e "Memory使用情况: "
	top -b -n 1 | grep "KiB Mem"

	# 找到消耗内存最多的前10个进程
	echo "消耗内存最多的前10个进程："
	ps -auxf | sort -nr -k 4 | head -10

	# split_line
}
########################################


# 检查运行队列大小，检查runnable的进程数量
# 每个处理器的运行队列大小不应超过3个，少于10倍的CPU个数，否则线程过多或者CPU不够
state=$(vmstat)
for line in $state do
	num=$line
done
echo $(num | awk '{print $1}')

# 查看Swap使用情况
echo -e "Swap使用情况: "
top -b -n 1 | grep Swap
split_line
echo -e "使用free命令查看："
free -m
split_line


# 比较某个用户与其他用户内存使用情况
compare_users_memory
# 检查并清除僵尸进程
check_clean_zombie