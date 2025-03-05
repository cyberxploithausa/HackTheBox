#!/bin/sh

KERNEL_VERSION=`cat /proc/version | awk '{print $3}'`
SNOOPING_MODULE=/lib/modules/$KERNEL_VERSION/kernel/drivers/net/ethernet/realtek/rtl86900/igmpHookModule/rtk_igmp_hook.ko

if [ -f $SNOOPING_MODULE ]; then
	echo "Loading Realtek IGMP/ MLD Snooping Module..."
	/bin/insmod $SNOOPING_MODULE
else
	echo "SNOOPING_MODULE not found\n"
fi
