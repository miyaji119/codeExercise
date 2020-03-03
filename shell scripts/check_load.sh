#!/bin/bash

########################################
# check load:
# - 多核情况下，真实的负载是需要除去CPU个数
#   + 如load为1，在1个CPU时，是满的；在2个CPU时，是50%
# - 如果Load Average高，但CPU的us、sy使用率低
#   + 这时要看一下磁盘IO或网络IO的等待时间
#   + 等待进程包括等待CPU时间片和等待IO（不可中断）
#   + 等待IO的进程的状态为“D”，可以通过ps aux的state列进行查看
#   + 磁盘的IO等待可以通过iostat -x查看，主要看await, svctm列
########################################

# uptime

cat /proc/loadavg

# 系统进程总数
process_num=$(cat /proc/loadavg | awk '{print $4}' | awk -F '/' '{print $2}')
# 正在运行的进程数
running_process_num=$(cat /proc/loadavg | awk '{print $4}' | awk -F '/' '{print $1}')

# 过去1分钟的load
load_one_min=$(uptime | awk -F ',' '{print $4}' | awk -F ':' '{print $2}')
# 过去5分钟的load
load_five_min=$(uptime | awk -F ',' '{print $5}')
# 过去15分钟的load
load_fifteen_min=$(uptime | awk -F ',' '{print $6}')

# CPU数
cpu_num=$(grep 'model name' /proc/cpuinfo | sort -u | wc -l)
# 物理CPU个数
pysical_cpu_num=$(grep 'physical id' /proc/cpuinfo | sort -u | wc -l)


# 每核的load情况
per_cpu_load_one_min=$(echo "scale=3;$load_one_min/$cpu_num" | bc)
per_cpu_load_five_min=$(echo "scale=3;$load_five_min/$cpu_num" | bc)
per_cpu_load_fifteen_min=$(echo "scale=3;$load_fifteen_min/$cpu_num" | bc)

echo "load avarage for each core: 0$per_cpu_load_one_min, 0$per_cpu_load_five_min, 0$per_cpu_load_fifteen_min"

# mail content function
function send_mail {
	local content="load avarage for each core is over 65%, kindly pay attention to the server."
	local mail_address="qixinhui119@163.com"
	local subject="[ATTENTION] high load"
	echo $content | mail -s $subject $mail_address
}

# 只要有一项数值大于0.65，就发送邮件
#if [[ $per_cpu_load_one_min -gt 0.65 || $per_cpu_load_five_min -gt 0.65 || $per_cpu_load_fifteen_min -gt 0.65 ]]; then
#	$send_mail
#fi

#
if [[ $per_cpu_load_one_min > 0.65 ]]; then
	echo "load avarage for each core in 1 min is larger than 65%."
elif [[ $per_cpu_load_five_min > 0.65 ]]; then
	echo "load avarage for each core in 5 min is larger than 65%."
elif [[ $per_cpu_load_fifteen_min > 0.65 ]]; then
	echo "load avarage for each core in 15 min is larger than 65%."
fi

