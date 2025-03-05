#!/bin/sh

pon_mode=`mib get PON_MODE`
Elan_mac=`mib get ELAN_MAC_ADDR`
fiber_mode=`flash get FIBER_MODE | sed 's/FIBER_MODE=//g'`
dev_pon_mode=`flash get DEV_PON_MODE | sed 's/DEV_PON_MODE=//g'`
if [ "$dev_pon_mode" == "" ]; then
	dev_pon_mode=2
fi
if [ "$pon_mode" == "PON_MODE=1" ]; then
	if [ ! -f /var/config/run_customized_sdk.sh ]; then
		cp /etc/run_customized_sdk.sh /var/config/run_customized_sdk.sh
	fi
		/var/config/run_customized_sdk.sh
		if [ -f /lib/modules/pf_rt_fc.ko ]; then
			ifconfig eth0 up
		fi
		/etc/runomci.sh
		if [ "$Elan_mac" != "ELAN_MAC_ADDR=00e04c867001" ]; then
			if [ "$dev_pon_mode" == "2" ]; then
				/bin/pondetect 1&
			fi
		fi
		echo "running GPON mode ..."
elif [ "$pon_mode" == "PON_MODE=2" ]; then
        insmod /lib/modules/epon_drv.ko
        /etc/runoam.sh
        insmod /lib/modules/epon_polling.ko
        insmod /lib/modules/epon_mpcp.ko
        sleep 2
	if [ "$Elan_mac" != "ELAN_MAC_ADDR=00e04c867001" ]; then
		if [ "$dev_pon_mode" == "2" ]; then
			/bin/pondetect 2&
		fi
	fi

        echo "running EPON mode ..."
elif [ "$pon_mode" == "PON_MODE=3" ]; then
        echo $fiber_mode > proc/fiber_mode
elif echo $pon_mode | grep -q "GET fail"; then
        echo $fiber_mode > proc/fiber_mode
else
        echo "running Ether mode..."
fi

insmod /lib/modules/rldp_drv.ko
#add realtek 
param_1453=`europacli get flash param 8290b 1453  1 |sed -n "2,2p"`
if [ "$param_1453" != "0x00" ]; then
europacli set flash param 8290b 1453 1 << EOF
0
EOF
fi
