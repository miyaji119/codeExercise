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
# - 检查Swap使用情况
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
	# if [[ $num -gt 0 ]]; then
		# 找到僵尸进程的PPID
		# ps -ef | grep defunct | grep -v grep | awk '{print $3}'
		# 杀掉僵尸进程的父进程
		# ps -ef | grep defunct | grep -v grep | awk '{print $3}' | xargs kill -9
	# fi
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

	split_line

	# 找到消耗CPU最多的前10个进程
	echo "消耗CPU最多的前10个进程："
	ps -eo pcpu,pid,user,args | sort -k 1 -r | head -10

	split_line
	
	# 检查CPU使用率
	US=$(vmstat | awk NR==3'{print $13}')
	SY=$(vmstat | awk NR==3'{print $14}')
	cpu_use=$[ $US + $SY ]
	
}

# - 检查Memory和Swap使用情况
function check_memory_swap {
	# 查看Memory使用情况
	echo -e "Memory使用情况: "
	top -b -n 1 | grep "KiB Mem"

	# 找到消耗内存最多的前10个进程
	echo "消耗内存最多的前10个进程："
	ps -auxf | sort -nr -k 4 | head -10

	split_line

	# 查看Swap使用情况
	echo -e "Swap使用情况: "
	top -b -n 1 | grep Swap
	
	split_line
	
	# echo -e "使用free命令查看："
	# free -m

	# 抓取物理内存free值
	memo_free=$( free -m | grep Mem | awk '{print $4}' )
	echo "Mem-free: $memo_free M"
	# 抓取缓冲区的free值
	# echo buffers/cache-free: $( free -m | grep - | awk '{print $4}' )M
	# 抓取Swap分区free值
	swap_free=$( free -m | grep Swap | awk '{print $4}' )
	echo "Swap-free: $swap_free M"
	# 当前已使用的Swap used大小
	swap_used=$( free -m | grep Swap | awk '{print $3}' )

	# 监控Swap分区情况，超过80%时警告
	# 报警阈值
	swap_warn=0.20

	if [[ $swap_used != 0 ]]; then
		# 如果交换分区已被使用，则计算当前剩余交换分区free所占总量的百分比，用小数来表示，要在小数点前面补一个整数位0 
		swap_per=0$( echo "scale=2;$swap_free/$swap_total" | bc )

		# 当前剩余交换分区百分比与阈值进行比较（当大于告警值(即剩余20%以上)时会返回1，小于(即剩余不足20%)时会返回0 ） 
		swap_now=$( expr $swap_per > $swap_warn )

		# 如果当前交换分区使用超过80%（即剩余小于20%，上面的返回值等于0），立即发邮件告警 
		if [[ $swap_now == 0 ]]; then 
			echo "Swap交换分区只剩下 $swap_free M 未使用，剩余不足20%，使用率已经超过80%"
		fi 
	fi

}
########################################


# 检查运行队列大小，检查runnable的进程数量（检查procs下的r列数值）
# 每个处理器的运行队列大小不应超过3个，少于10倍的CPU个数，否则线程过多或者CPU不够
num=$(vmstat |awk  NR==3'{print $1}')
if [[ $num -gt 3 ]]; then
	echo "runnable processes is: $num"
fi
echo "runnable的进程数量：$num"



# 比较某个用户与其他用户内存使用情况
compare_users_memory
# 检查CPU使用情况
check_cpu_situation
# 检查Memory使用情况
check_memory_swap
# 检查并清除僵尸进程
# check_clean_zombie