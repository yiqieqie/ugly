# 通过 有名管道的方式进行 并发操作


#####################
[[ -e /tmp/fd1 ]] || mkfifo /tmp/fd1 #创建有名管道
exec 666<>/tmp/fd1                   #创建文件描述符，以可读（<）可写（>）的方式关联管道文件，这时候文件描述符3就有了有名管道文件的所有特性
rm -rf /tmp/fd1                      #关联后的文件描述符拥有管道文件的所有特性,所以这时候管道文件可以删除，我们留下文件描述符来用就可以了
for((ii=1;ii<=$concurrent_number;ii++))
do
    echo >&666                       #&3代表引用文件描述符3，这条命令代表往管道里面放入了一个"令牌"
done
#####################


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



exec 666<&-                       #关闭文件描述符的读
exec 666>&-                       #关闭文件描述符的写
