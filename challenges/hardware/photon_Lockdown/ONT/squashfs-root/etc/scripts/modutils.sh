#!/bin/sh
### BEGIN INIT INFO
# Provides:          module-init-tools
# Required-Start:    
# Required-Stop:     
# Should-Start:      checkroot
# Should-stop:
# Default-Start:     S
# Default-Stop:
# Short-Description: Process /etc/modules.
# Description:       Load the modules listed in /etc/modules.
### END INIT INFO
str2hex()
{
  I=0
  while [ $I -lt ${#1} ];
  do
    printf "%02x" "'${1:$I:1}";
    let "I += 1"
  done
}
toBig() {
  v=$1
  v2=$(( ($v<<8 & 0xff00ff00) | ($v>>8 & 0xff00ff) ))
  v2=$(( (v2<<16 & 0xffff0000) | v2>>16 ))
  printf '0x%08x\n' $v2
}

pon_mode=`flash get PON_MODE`
pon_speed=`flash get PON_SPEED`
scfg_file=/config/scfg.txt

ca_rtk_pon_set_scfg() {
    if [ -f $scfg_file ] ; then
        cur=`grep CFG_ID_PON_MAC_MODE $scfg_file | awk '{print $NF}' | sed 's/;$//'`
        cur_voq=`grep CFG_ID_PON_VOQ_MODE $scfg_file | awk '{print $NF}' | sed 's/;$//'`
        cur_vendor=`grep CFG_ID_PON_VENDOR_ID $scfg_file | awk '{print $NF}' | sed 's/;$//'`
        cur_vssn=`grep CFG_ID_PON_VSSN $scfg_file | awk '{print $NF}' | sed 's/;$//'`
        if [ "$pon_mode" == "PON_MODE=1" ] && [ "$pon_speed" != "PON_SPEED=0" ]; then
            gpon_vendor=`flash get GPON_SN | cut -c 9-12`
            gpon_vssn=`flash get GPON_SN | cut -c 13-20`
            gpon_vssn="0x$gpon_vssn"
            ngpon_pwd=`flash get GPON_PLOAM_PASSWD | cut -d '=' -f2 `
            ngpon_pwd_hex=`str2hex $ngpon_pwd`
            pad="000000000000000000000000000000000000000000000000000000000000000000000000"
            ngpon_pwd_hex=`printf '%s%*.*s\n' "$ngpon_pwd_hex" 0 $((72 - ${#ngpon_pwd_hex})) "$pad"`

            for i in  0 1 2 3 4 5 6 7 8
            do
                scfg_regX=`grep CFG_ID_PON_REGISTRATION_ID$i $scfg_file | awk '{print $NF}' | sed 's/^=//' | sed 's/;$//'`
                scfg_reg="$scfg_reg""`toBig $scfg_regX | sed 's/^0x//'`"
            done
        fi
        if [ "$pon_mode" == "PON_MODE=1" ]; then
            if [ "$pon_speed" == "PON_SPEED=1" ]; then
                if [ "$cur" != "0x04" ]; then
                    sed -i  '/CFG_ID_PON_MAC_MODE/d' $scfg_file
                    sed -i  '$a CHAR CFG_ID_PON_MAC_MODE = 0x04;' $scfg_file
                    echo "setting CFG_ID_PON_MAC_MODE of scfg to XGPON1(0x04) ..."
                fi
            elif [ "$pon_speed" == "PON_SPEED=2" ]; then
                if [ "$cur" != "0x05" ]; then
                    sed -i  '/CFG_ID_PON_MAC_MODE/d' $scfg_file
                    sed -i  '$a CHAR CFG_ID_PON_MAC_MODE = 0x05;' $scfg_file
                    echo "setting CFG_ID_PON_MAC_MODE of scfg to XGSPON(0x05) ..."
                fi
            else
                echo "not supporting pon_mode=$pon_mode and pon_speed=$pon_speed ..."
                return 0
            fi
            if [ "$cur_voq" != "0x0" ]; then
                sed -i  '/CFG_ID_PON_VOQ_MODE/d' $scfg_file
                sed -i  '$a CHAR CFG_ID_PON_VOQ_MODE = 0x0;' $scfg_file
                echo "setting CFG_ID_PON_VOQ_MODE of scfg to VOQ_M_8Q(0x0) ..."
            fi
            if [ "$cur_vendor" != "$gpon_vendor" ] && [ "$gpon_vendor" != "" ]; then
                sed -i  '/CFG_ID_PON_VENDOR_ID/d' $scfg_file
                sed -i  "\$a STRING CFG_ID_PON_VENDOR_ID = $gpon_vendor;" $scfg_file
                echo "setting scfg CFG_ID_PON_VENDOR_ID=$gpon_vendor"
            fi
            if [ "$cur_vssn" != "$gpon_vssn" ] && [ "$gpon_vssn" != "0x" ]; then
                sed -i  '/CFG_ID_PON_VSSN/d' $scfg_file
                sed -i  "\$a INT CFG_ID_PON_VSSN = $gpon_vssn;" $scfg_file
                echo "setting scfg CFG_ID_PON_VSSN=$gpon_vssn"
            fi
            if [ "$scfg_reg" != "$ngpon_pwd_hex" ]; then
                sed -i  '/CFG_ID_PON_REGISTRATION_ID/d' $scfg_file
                echo scfg_reg=$scfg_reg
                for i in 0 1 2 3 4 5 6 7 8
                do
                    offset=`expr $i \* 8`
                    scfg_regX=`toBig 0x${ngpon_pwd_hex:$offset:8}`
                    sed -i "\$a INT CFG_ID_PON_REGISTRATION_ID$i = $scfg_regX;" $scfg_file
                    echo "setting scfg CFG_ID_PON_REGISTRATION_ID$i=$scfg_regX"
                done
            fi			
        elif [ "$pon_mode" == "PON_MODE=2" ]; then
            if [ "$pon_speed" == "PON_SPEED=1" ]; then
                if [ "$cur" != "0x01" ]; then
                    sed -i  '/CFG_ID_PON_MAC_MODE/d' $scfg_file
                    sed -i  '$a CHAR CFG_ID_PON_MAC_MODE = 0x01;' $scfg_file
                    echo "setting CFG_ID_PON_MAC_MODE of scfg to EPON-D10G(0x01) ..."
                fi
            elif [ "$pon_speed" == "PON_SPEED=2" ]; then
                if [ "$cur" != "0x02" ]; then
                    sed -i  '/CFG_ID_PON_MAC_MODE/d' $scfg_file
                    sed -i  '$a CHAR CFG_ID_PON_MAC_MODE = 0x02;' $scfg_file
                    echo "setting CFG_ID_PON_MAC_MODE of scfg to EPON-BI10G(0x02) ..."
                fi
            else
                echo "not supporting pon_mode=$pon_mode and pon_speed=$pon_speed ..."
                return 0
            fi
            if [ "$cur_voq" != "0x0" ]; then
                sed -i  '/CFG_ID_PON_VOQ_MODE/d' $scfg_file
                sed -i  '$a CHAR CFG_ID_PON_VOQ_MODE = 0x0;' $scfg_file
                echo "setting CFG_ID_PON_VOQ_MODE of scfg to VOQ_M_8Q(0x0) ..."
            fi
            macaddr=`flash get EPON_LLID_TBL.0.macAddr | sed 's/^.*=//g'`
            if [ "$macaddr" == "" ] ; then
                macaddr=`flash get ELAN_MAC_ADDR | sed 's/^.*=//g'`
                if [ "$macaddr" == "" ] ; then
                    echo "not supporting setting EPON MAC to scfg ..."
                    return 0
                fi
                #echo "ELAN_MAC_ADDR=00e04c867001" | sed 's/ELAN_MAC_ADDR=//g' | sed 's/..\B/&:/g'
                format_mac=`echo $macaddr | sed 's/^.*=//g' | sed 's/..\B/&:/g'`
            else
                #t_mac_1=`echo "macAddr=13:2500:1::" | sed 's/^.*=//g' | awk -F":" '{if(length($1)==0) printf(0x0);else printf("0x%s",$1)}'`
                #t_mac_2=`echo "macAddr=13:2500:1::" | sed 's/^.*=//g' | awk -F":" '{if(length($2)==0) printf(0x0);else printf("0x%s",$2)}'`
                #t_mac_3=`echo "macAddr=13:2500:1::" | sed 's/^.*=//g' | awk -F":" '{if(length($3)==0) printf(0x0);else printf("0x%s",$3)}'`
                #printf "%04x%04x%04x" $t_mac_1 $t_mac_2 $t_mac_3 | sed 's/..\B/&:/g'
                t_mac_1=`echo $macaddr | sed 's/^.*=//g' | awk -F":" '{if(length($1)==0) printf(0x0);else printf("0x%s",$1)}'`
                t_mac_2=`echo $macaddr | sed 's/^.*=//g' | awk -F":" '{if(length($2)==0) printf(0x0);else printf("0x%s",$2)}'`
                t_mac_3=`echo $macaddr | sed 's/^.*=//g' | awk -F":" '{if(length($3)==0) printf(0x0);else printf("0x%s",$3)}'`
                format_mac=`printf "%04x%04x%04x" $t_mac_1 $t_mac_2 $t_mac_3 | sed 's/..\B/&:/g'`
            fi
            #grep CFG_ID_MAC_ADDRESS /config/scfg.txt | awk -F" " '{print $NF}' | sed 's/;//'
            ori_mac=`grep CFG_ID_MAC_ADDRESS /config/scfg.txt | awk -F" " '{print $NF}' | sed 's/;//'`
            if [ "$ori_mac" != "$format_mac" ] ; then
                sed -i  '/CFG_ID_MAC_ADDRESS/d' $scfg_file
                sed -i  '$a MAC CFG_ID_MAC_ADDRESS = '"$format_mac"'' $scfg_file
                echo "setting CFG_ID_MAC_ADDRESS of scfg to $format_mac ..."
            fi
        else
            echo "not supporting pon_mode=$pon_mode ..."
            return 0
        fi
    else
        echo "Not exist $scfg_file!! Please check it!!"
        return 0
    fi
    return 1
}

rtk_pon_set_scfg() {
    echo "RTL Chip............"
    return 1
}
#Calling presetting scfg
if [ -f /lib/modules/`uname -r`/extra/ca-rtk.ko ] ; then
ca_rtk_pon_set_scfg
modprobe ca-rtk
else
rtk_pon_set_scfg
fi

LOAD_MODULE=modprobe
[ -f /proc/modules ] || exit 0
[ -f /etc/modules ] || [ -d /etc/modules-load.d ] || exit 0
[ -e /sbin/modprobe ] || LOAD_MODULE=insmod

if [ ! -f /lib/modules/`uname -r`/modules.dep ]; then
    [ "$VERBOSE" != no ] && echo "Calculating module dependencies ..."
    depmod -Ae
fi

loaded_modules=" "

process_file() {
    file=$1

    (cat $file; echo; ) |
    while read module args
    do
        case "$module" in
            \#*|"") continue ;;
        esac
        [ -n "$(echo $loaded_modules | grep " $module ")" ] && continue
        [ "$VERBOSE" != no ] && echo -n "$module "
        eval "$LOAD_MODULE $module $args >/dev/null 2>&1"
        loaded_modules="${loaded_modules}${module} "
    done
}


[ "$VERBOSE" != no ] && echo -n "Loading modules: "
[ -f /etc/modules ] && process_file /etc/modules

[ -d /etc/modules-load.d ] || exit 0

for f in /etc/modules-load.d/*.conf; do
    process_file $f
done


#######Other modules without module_dependency

if [ -f /lib/modules/`uname -r`/kernel/drivers/net/ethernet/realtek/rtl86900/FleetConntrackDriver/fc_mgr.ko ]; then
        modprobe fc_mgr
fi
if [ -f /lib/modules/`uname -r`/kernel/drivers/net/ethernet/realtek/rtl86900/FleetConntrackDriver/fc_8198f.ko ]; then
        modprobe fc_8198f
        modprobe fc_8198f_hook
fi
if [ -f /lib/modules/`uname -r`/kernel/drivers/net/ethernet/realtek/rtl86900/romeDriver/rg.ko ]; then
        modprobe rg
fi
if [ -f /lib/modules/`uname -r`/kernel/drivers/net/ethernet/realtek/rtl86900/sdk/src/module/ext_phy_polling/ext_phy_polling.ko ]; then
        $LOAD_MODULE /lib/modules/`uname -r`/kernel/drivers/net/ethernet/realtek/rtl86900/sdk/src/module/ext_phy_polling/ext_phy_polling.ko
fi
##### Wifi #############
if [ -f /lib/modules/`uname -r`/kernel/drivers/net/wireless/realtek/rtl8192cd/rtl8192cd.ko ]; then
        modprobe rg
        modprobe rtl8192cd
fi
if [ -f /lib/modules/`uname -r`/kernel/drivers/net/wireless/realtek/rtl8192cd-link/rtl8192cd.ko ]; then
        modprobe rg
        modprobe rtl8192cd
fi

[ "$VERBOSE" != no ] && echo

exit 0
