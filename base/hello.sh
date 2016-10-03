#!/bin/bash     #标识执行脚本的shell工具
echo "hello world \a \n"      

echo "input your username:"
read username     #通过read命令接收用户的输入
echo "your username is " $username       #通过$来显示变量值



exit 0            #程序退出，并返回执行结果。使用 $? 可以获得执行结果.执行脚本之后，接着执行 echo $?   ，会得到   0


 
