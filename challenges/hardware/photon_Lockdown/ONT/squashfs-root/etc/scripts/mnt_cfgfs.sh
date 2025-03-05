#!/bin/sh

# Mount /var/config based mtd partitin name "config"
# $1: arguments for mount command (file system type and etc) 
# $2: mtd name
# $3: directory to be mounted onto

# Parameters validation
if [ $# != 3 ]; then
    echo "Argument is $#, but it should be 3"
    echo "Usage: $0 <arguments for mount command> <mtd_name> <directory>"
    echo "<arguments for mount command> e.g., \"-t jffs2\", or \"-t  yaffs2 -o tags-ecc-off\""
    echo "<mtd_name> e.g., \"config\""
    echo "<directory> e.g., \"/var/config\""
    exit 1
fi

mount_param="$1"
mtd_name="$2"
mount_dir="$3"

# Check existence of destination direcotry 
if [ ! -d "${mount_dir}" ]; then
    # Try to create it if it doesn't exist
    mkdir -p ${mount_dir}
    if [ $? != 0 ]; then
        echo "Error: directory ${mount_dir} doesn't exist and cannot be created"
        # exit if fails
	exit 2
    fi
fi


# Find out mtd ID by name
cfgfs_mtd=`cat /proc/mtd | grep "${mtd_name}" | sed 's/^mtd\(.*\):.*$/\1/g'`
echo "Mounting /dev/mtdblock"$cfgfs_mtd" onto ${mount_dir} as the configuration data storage"

mtd_valid=`ls "/dev/mtdblock""$cfgfs_mtd"`
if [ "$mtd_valid" == "" ]; then
    echo "Warning: cannot find the corresponding MTD to mount."
    exit 2
fi

fs_ok="${mount_dir}/"".cfgfs_ok_"
# Try mounting 
try_format="no"
mount ${mount_param} "/dev/mtdblock""$cfgfs_mtd" ${mount_dir}
# Try formating the paration if fails 
if [ $? != 0 ]; then
    echo "Error: failed to mount "/dev/mtdblock""$cfgfs_mtd" onto "${mount_dir}""
    try_format="failed to mount"
else 
    fs_sig=`ls ${fs_ok}*`
    if [ "$fs_sig" == "" ]; then
        echo "The partition is fresh."
        nand_fs="yaffs2"
        if [ "${mount_param}" != "${mount_param%$nand_fs*}" ]; then
            try_format="fresh yaffs2 partition"
        else
            echo "${mount_dir} is successfully created with `cat /proc/version`" 
            echo "" > "$fs_ok"`cat /proc/version | sed 's/ /_/g'`
        fi
    fi
fi

# if [ $try_format != 0 ]; then
if [ "$try_format" != "no" ]; then
    echo "Trying to format "/dev/mtd""$cfgfs_mtd"... "
    umount -f ${mount_dir}
    echo "Erasing partition... "
    flash_erase "/dev/mtd""$cfgfs_mtd" 0 0
    if [ $? != 0 ]; then
        echo "Error: failed to format "dev/mtd""$cfgfs_mtd""
        exit 3
    else
        echo "Format ok, trying to mount again..."
        mount ${mount_param} "/dev/mtdblock""$cfgfs_mtd" ${mount_dir}
        # exit if fails
        if [ $? != 0 ]; then
            echo "Error: Failed to mount "/dev/mtdblock""$cfgfs_mtd" onto "${mount_dir}""
            exit 4
        else
            echo "${mount_dir} is successfully created with `cat /proc/version`" 
            echo "" > "$fs_ok"`cat /proc/version | sed 's/ /_/g'`
        fi
    fi
fi


