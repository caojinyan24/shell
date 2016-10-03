#!/bin/bash
#在执行脚本命令的时候使用输入的参数

if [ "$1" = "hello" ];     #$0表示文件名，$1,$2。。分别表示文件名之后的各个参数，按照顺序标识
then echo "hello,how are you?"
elif [ "$1" = "" ];
then echo "please input you parameters,ex>$0 someword"
else echo "The only parameter is 'hello'"
fi
