#!/bin/sh

get_omci_dbg_level ()
{
	dbgLevel=`mib get OMCI_DBGLVL | sed 's/OMCI_DBGLVL=//g'`

	case "$dbgLevel" in
		0)
			dbgLevel_opt="err"
			;;
		1)
			dbgLevel_opt="err"
			;;
		2)
			dbgLevel_opt="warn"
			;;
		3)
			dbgLevel_opt="info"
			;;
                4)
                        dbgLevel_opt="dbg"
                        ;;
		*)
			dbgLevel_opt="off"
			;;
	esac
	echo $dbgLevel_opt
}

get_omci_log_format ()
{
	logFormat=`mib get OMCI_LOGFILE | sed 's/OMCI_LOGFILE=//g'`
	logMask=`mib get OMCI_LOGFILE_MASK | sed 's/OMCI_LOGFILE_MASK=//g'`

	case "$logFormat" in
		0)
			logFormat_opt="off"
			;;
		1)
			logFormat_opt="raw"
			;;
		2)
			logFormat_opt="parsed"
			;;
		3)
			logFormat_opt="both"
			;;
		7)
			logFormat_opt="time"
			;;
		8)
			logFormat_opt="console"
			;;
		*)
			logFormat_opt="off"
			;;
	esac
	logFormat_opt=$logFormat_opt" $logMask"
	echo $logFormat_opt
}

get_omci_dual_mgmt_mode ()
{
	dualMgmt=`mib get DUAL_MGMT_MODE | sed 's/DUAL_MGMT_MODE=//g'`

	case "$dualMgmt" in
		0)
			dualMgmt_opt="disable"
			;;
		1)
			dualMgmt_opt="enable_wq"
			;;
		2)
			dualMgmt_opt="enable_bc_mc"
			;;
		3)
			dualMgmt_opt="enable_wq_bc_mc"
			;;
		*)
			dualMgmt_opt="disable"
			;;
	esac
	echo $dualMgmt_opt
}

get_omci_dev_type ()
{
	devType=`mib get DEVICE_TYPE | sed 's/DEVICE_TYPE=//g'`

	case "$devType" in
		0)
			devType_opt="bridge"
			;;
		1)
			devType_opt="router"
			;;
		2)
			devType_opt="hybrid"
			;;
		*)
			devType_opt="bridge"
			;;
	esac
	echo $devType_opt
}

get_omci_pon_speed ()
{
	ponSpeed=`mib get PON_SPEED | sed 's/PON_SPEED=//g'`

	case "$ponSpeed" in
		0)
			ponSpeed="gpon"
			;;
		1)
			ponSpeed="xgpon1"
			;;
		2)
			ponSpeed="xgspon"
			;;
		*)
			ponSpeed="gpon"
			;;
	esac
	echo $ponSpeed
}

get_omci_cus_conf ()
{
	cus_conf=""
        cus_bridge=`mib get OMCI_CUSTOM_BDP | sed 's/OMCI_CUSTOM_BDP=//g'`
        if [ -n "$cus_bridge" ]; then
                cus_conf=$cus_conf" -cb $cus_bridge"
        fi

        cus_route=`mib get OMCI_CUSTOM_RDP | sed 's/OMCI_CUSTOM_RDP=//g'`
        if [ -n "$cus_route" ]; then
                cus_conf=$cus_conf" -cr $cus_route"
        fi

        cus_mcast=`mib get OMCI_CUSTOM_MCAST | sed 's/OMCI_CUSTOM_MCAST=//g'`
        if [ -n "$cus_mcast" ]; then
                cus_conf=$cus_conf" -cmc $cus_mcast"
        fi

        cus_me=`mib get OMCI_CUSTOM_ME | sed 's/OMCI_CUSTOM_ME=//g'`
        if [ -n "$cus_me" ]; then
                cus_conf=$cus_conf" -cme $cus_me"
        fi


        echo $cus_conf
}

get_omci_iot_vlan_cfg ()
{
	iot_vlan_cfg=""
	vlan_type=`mib get VLAN_CFG_TYPE | sed 's/VLAN_CFG_TYPE=//g' | grep -v fail`
	vlan_manu_mode=`mib get VLAN_MANU_MODE | sed 's/VLAN_MANU_MODE=//g' | grep -v fail`
	vlan_manu_vid=`mib get VLAN_MANU_TAG_VID | sed 's/VLAN_MANU_TAG_VID=//g' | grep -v fail`
	vlan_manu_pri=`mib get VLAN_MANU_TAG_PRI | sed 's/VLAN_MANU_TAG_PRI=//g' | grep -v fail`

	if [ -n "$vlan_type" ]; then

		case "$vlan_type" in
			1)
				case "$vlan_manu_mode" in
					1)
						if [ -n "$vlan_manu_vid" ] && [ -n "$vlan_manu_pri" ]; then
							iot_vlan_cfg=$iot_vlan_cfg" -iot_vt 1 -iot_vm 1 -iot_vid $vlan_manu_vid -iot_pri $vlan_manu_pri"
						fi
						;;
					*)
						if [ -z "$vlan_manu_mode" ]; then
							vlan_manu_mode=255
						fi
						iot_vlan_cfg=$iot_vlan_cfg" -iot_vt 1 -iot_vm $vlan_manu_mode -iot_vid 65535 -iot_pri 255"
						;;
				esac
				;;
			*)
				if [ -z "$vlan_manu_mode" ]; then
					vlan_manu_mode="255"
				fi
				iot_vlan_cfg=$iot_vlan_cfg" -iot_vt 0 -iot_vm $vlan_manu_mode -iot_vid 65535 -iot_pri 255"
				;;
		esac
	fi
	echo $iot_vlan_cfg
}

get_omci_veip_slot_id_conf ()
{
	veip_slot_id_conf=""
    
	veip_slot_value=`mib get OMCI_VEIP_SLOT_ID | sed 's/OMCI_VEIP_SLOT_ID=//g'`
    
	if [ -n "$veip_slot_value" ]; then
		veip_slot_id_conf=$veip_slot_id_conf" -slot_veip $veip_slot_value"
	fi
	
	echo $veip_slot_id_conf
}

get_omci_voice_vendor ()
{
	voice_vendor=""

	if [ -f /etc/rc_voip ]; then
		voice_vendor=$voice_vendor" -voice_vendor 1"
	else
		voice_vendor=$voice_vendor" -voice_vendor 0"
	fi
    
	echo $voice_vendor
}

get_omci_pon_mac_filter_mc_conf ()
{
	pon_mac_filter_mc_conf=""
	
	if [ ! -f /var/config/igmp_gpon.conf ]; then
		pon_mac_filter_mc_conf=$pon_mac_filter_mc_conf" -pon_mac_filter_mc 0"
	else
		pon_mac_filter_mc_flag=`cat /var/config/igmp_gpon.conf | grep gponMacFilterMc | sed 's/^gponMacFilterMc=//g'`
		if [ -z "$pon_mac_filter_mc_flag" ] || [ "$pon_mac_filter_mc_flag" = "0" ]; then
			pon_mac_filter_mc_conf=$pon_mac_filter_mc_conf" -pon_mac_filter_mc 0"
		else
			pon_mac_filter_mc_conf=$pon_mac_filter_mc_conf" -pon_mac_filter_mc 1"
		fi
	fi
    
	echo $pon_mac_filter_mc_conf
}

gpon_sn=`mib get GPON_SN | sed 's/GPON_SN=//g'`
gpon_ploam_pwd=`mib get GPON_PLOAM_PASSWD | sed 's/GPON_PLOAM_PASSWD=//g'`
gpon_loid=`mib get LOID | sed 's/LOID=//g' | grep -v entry | grep -v failed`
gpon_loid_old=`mib get LOID_OLD | sed 's/LOID_OLD=//g' | grep -v entry | grep -v failed`
gpon_loidPwd=`mib get LOID_PASSWD | sed 's/LOID_PASSWD=//g' | grep -v entry | grep -v failed`
gpon_loidPwd_old=`mib get LOID_PASSWD_OLD | sed 's/LOID_PASSWD_OLD=//g' | grep -v entry | grep -v failed`
omci_cusOpt_debug=`cat /var/config/omci_custom_opt.conf | grep DEBUG_MODE | sed 's/# *DEBUG_MODE=//g'`
omci_mibCfg_debug=`cat /var/config/omci_mib.cfg | grep DEBUG_MODE | sed 's/# *DEBUG_MODE=//g'`
omci_ignoreMib_debug=`cat /var/config/omci_ignore_mib_tbl.conf | grep DEBUG_MODE | sed 's/# *DEBUG_MODE=//g'`
omci_psk=`mib get OMCI_PSK | sed 's/OMCI_PSK=//g'`

if [ ! -f /var/config/omci_custom_opt.conf ] || [ "$omci_cusOpt_debug" = "0" ] || [ -z "$omci_cusOpt_debug" ]; then
	cp -af /etc/omci_custom_opt.conf /var/config/omci_custom_opt.conf 
fi

if [ ! -f /var/config/omci_mib.cfg ] || [ "$omci_mibCfg_debug" = "0" ] || [ -z "$omci_mibCfg_debug" ]; then
	cp -af /etc/omci_mib.cfg /var/config/omci_mib.cfg
fi

if [ ! -f /var/config/omci_ignore_mib_tbl.conf ] || [ "$omci_ignoreMib_debug" = "0" ] || [ -z "$omci_ignoreMib_debug" ]; then
	if [ "$(get_omci_pon_speed)" = "gpon" ]; then
		cp -af /etc/omci_ignore_mib_tbl.conf /var/config/omci_ignore_mib_tbl.conf
	else
		cp -af /etc/omci_ignore_mib_tbl_10g.conf /var/config/omci_ignore_mib_tbl.conf
	fi		
fi

if [ -n "$gpon_ploam_pwd" ]; then
 	gpon_ploam_pwd_set="-p $gpon_ploam_pwd"
else
  	gpon_ploam_pwd_set=""
fi

if [ -n "$omci_psk" ]; then
  	omci_psk_set="-psk $omci_psk"
else
  	omci_psk_set=""
fi

if [ "$gpon_loid_old" == "$gpon_loid" ]; then
	if [ -n "$gpon_loid" ]; then
 		gpon_loid_set="-l $gpon_loid"
	else
 		gpon_loid_set=""
	fi
else
	if [ -n "$gpon_loid_old" ]; then
		gpon_loid_set="-l $gpon_loid_old"
	else
		gpon_loid_set=""
	fi
fi


if [ "$gpon_loid_old" == "$gpon_loid" ]; then
	if [ -n "$gpon_loidPwd" ]; then
		gpon_loidPwd_set="-w $gpon_loidPwd"
	else
    	gpon_loidPwd_set=""
	fi
else
	if [ -n "$gpon_loidPwd_old" ]; then
		gpon_loidPwd_set="-w $gpon_loidPwd_old"
	else
		gpon_loidPwd_set=""
	fi
fi

if [ $(get_omci_dev_type) == "bridge" ]; then
	/etc/runigmp.sh
fi

omci_app -ps $(get_omci_pon_speed) -s $gpon_sn -f $(get_omci_log_format) -m $(get_omci_dual_mgmt_mode) -d $(get_omci_dbg_level) -t $(get_omci_dev_type) $gpon_ploam_pwd_set $gpon_loid_set $gpon_loidPwd_set $omci_psk_set $(get_omci_cus_conf) $(get_omci_iot_vlan_cfg) $(get_omci_veip_slot_id_conf) $(get_omci_voice_vendor) $(get_omci_pon_mac_filter_mc_conf) &

