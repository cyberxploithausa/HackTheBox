#!/bin/sh

exeCmd="eponoamd "
i=0
result=`flash get EPON_LLID_TBL.$i.macAddr | sed 's/macAddr=//g'`
result1=`echo $result | grep 'fail'`
if [ "$result" == "" ] || [ "$result1" != "" ]
then
    macaddr=`flash get ELAN_MAC_ADDR | sed 's/ELAN_MAC_ADDR=//g'`
    exeCmd=$exeCmd" -mac "$i" "$macaddr" "
    i=$((i+1))
    result=`flash get EPON_LLID_TBL.$i.macAddr | sed 's/macAddr=//g'`
	result1=`echo $result | grep 'fail'`
fi

while [ "$result" != "" ] && [ "$result1" == "" ]
do
macaddr=`flash get EPON_LLID_TBL.$i.macAddr | sed 's/macAddr=//g'`
<<'COMMENT1'
count=`echo $macaddr | awk -v RS=':' 'END {print --NR}'`
if [ ${count} == 3 ]
then
	tmp=`echo $macaddr | sed 's/:://g'`
	macaddr=`printf %s:0:: ${tmp}`
elif [ ${count} == 2 ]
then
	tmp=`echo $macaddr | sed 's/:://g'`
	macaddr=`printf %s:0:0:: ${tmp}`
fi
macaddr0=`echo $macaddr | sed 's/:[0-9a-fA-F]*:[0-9a-fA-F]*:://g'`
macaddr1=`echo $macaddr | sed 's/:[0-9a-fA-F]*:://g' | sed 's/[0-9a-fA-F]*://g'`
macaddr2=`echo $macaddr | sed 's/^[0-9a-fA-F]*:[0-9a-fA-F]*://g' | sed 's/:://g'`
macaddr0=`echo "0x"$macaddr0`
macaddr1=`echo "0x"$macaddr1`
macaddr2=`echo "0x"$macaddr2`
macaddr=`printf %04x%04x%04x $macaddr0 $macaddr1 $macaddr2`
COMMENT1

exeCmd=$exeCmd"-mac "$i" "$macaddr" "

i=$((i+1))
result=`flash get EPON_LLID_TBL.$i.macAddr | sed 's/macAddr=//g'`

result1=`echo $result | grep 'fail'`
if [ "$result1" != "" ]
then
    break
fi

done

$exeCmd &

