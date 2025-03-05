#!/bin/sh
if [ $(sed '/^HighTotal: */!d; s///;/kb/d;s/ kB//;q' /proc/meminfo) -gt 0 ]; then
/bin/echo 18432 > /proc/sys/vm/min_free_kbytes ;
echo "HIGHMEM : Avoid memory deadlock. vm.min_free_kbytes = $(cat /proc/sys/vm/min_free_kbytes)";
/bin/echo "32 128" > /proc/sys/vm/lowmem_reserve_ratio;
/bin/echo 200 > /proc/sys/vm/vfs_cache_pressure ;
fi

