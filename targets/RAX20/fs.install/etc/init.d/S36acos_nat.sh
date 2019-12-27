#!/bin/sh
echo "=============S36 Insert Acos_nat.ko start!"

if [ -f /proc/nvram/wl_nand_manufacturer ]; then
	is_mfg=`cat /proc/nvram/wl_nand_manufacturer`
	echo "=====================is_mfg= $is_mfg"
#	case $is_mfg in
#		2|3|6|7)
#			echo "=====================IN WLTEST driver, insert acos_nat!!" 
#			/bin/mknod -m 755 /dev/acos_nat_cli c 100 0
#			/sbin/insmod /lib/modules/4.1.52/extra/acos_nat.ko
#			;;
#		*)
#			;;
#	esac
fi
