
the_pon_mode=`mib get PON_MODE | sed 's/PON_MODE=//g'`

while [  "$the_pon_mode" != "1" ] && [ "$the_pon_mode" != "2" ]
do
	echo "Waitting for configd startup"
	sleep 1
	the_pon_mode=`mib get PON_MODE | sed 's/PON_MODE=//g'`
done
dev_pon_mode=`mib get DEV_PON_MODE | sed 's/DEV_PON_MODE=//g'`

if [ "$dev_pon_mode" == "0" ]; then
	if [ "$the_pon_mode" != "1" ]; then
		mib set PON_MODE 1
		mib commit hs
	fi
elif [ "$dev_pon_mode" == "1" ]; then
	if [ "$the_pon_mode" != "2" ]; then
		mib set PON_MODE 2
		mib commit hs
	fi
fi

