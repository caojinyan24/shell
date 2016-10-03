#!/bin/bash
echo "use touch command to create file"
echo "input the file name" 
read filenameuser

#若filenameusuer输入为空，filename值为filename，否则，取输入的filenameuser
filename=${filenameuser:-"filename"}

#反单引号`表示执行命令行
date1=`date --date='2 days ago' +%Y%m%d`
date2=`date --date='1 days ago' +%Y%m%d`
date3=`date +%Y%m%d`

#拼接新字符串变量
file1="$filename""$date1"
file2="$filename""$date2"
file3="$filename""$date3"

#创建文件名
touch $file1
touch $file2
touch $file3

#逻辑判断
test -f $file1 &&echo "exist"||echo "not exist"

#通过$(())进行数值运算
echo $((2*76))>$file1

#赋值，这里注意要用反单引号，表示执行命令
value=`cat $file1`

#通过[]进行逻辑判断
echo "判断2*76是否等于152"
[  "$value" = "152" ] && echo "equal"||echo "unequal"

#清理之前产生的垃圾文件
rm $file1
rm $file2
rm $file3

#逻辑判断
echo "please input (Y/N):" 
read yn
if [ "$yn" = "Y" ]||[ "$yn" = "y" ]; 
then echo "OK,continue"
elif [ "$yn" = "N" ] || [ "$yn" = "n" ];
then echo "abort"
else echo "error input"
fi



