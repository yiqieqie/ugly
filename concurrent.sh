##########################并发任务########################################

while read line
do
read -u666
{
    #命令执行
    echo "line: $line"
    $line
    #sleep 3
    echo >&666
} &
done < $log_file

wait


##########################并发任务########################################
