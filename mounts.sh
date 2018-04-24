# This is specific to my uuids.

# very important to MKDIR mount points!!!

# mkdir -p /data/hd0/p0
# mount UUID="5b98d9ef-2962-44d1-8e47-843190364473" /data/hd0/p0
mkdir -p /data/hd0/p0
disk_uuid=5b98d9ef-2962-44d1-8e47-843190364473
if ! grep -q ${disk_uuid} /etc/fstab; then
    echo '' >> /etc/fstab
    echo '# hd0 ext4 datastore' >> /etc/fstab
    echo "UUID=${disk_uuid}		/data/hd0/p0	auto 	defaults	0	1" >> /etc/fstab
else
    echo 'skipping hd0 ext4 datastore'
fi

 
# mkdir -p /data/hd0/p1
# mount UUID="0CD215CED215BD40" /data/hd0/p1
mkdir -p /data/hd0/p1
disk_uuid=0CD215CED215BD40
if ! grep -q ${disk_uuid} /etc/fstab; then
    echo '' >> /etc/fstab
    echo '# hd0 ntfs datastore' >> /etc/fstab
    echo "UUID=${disk_uuid}	/data/hd0/p1	auto 	defaults	0	1" >> /etc/fstab
else
    echo 'skipping hd0 ntfs datastore'
fi
 
# mkdir -p /data/hd0/p2
# mount UUID="029e3f11-b69f-4662-b05d-145040ca74b3" /data/hd0/p2
mkdir -p /data/hd0/p2
disk_uuid=029e3f11-b69f-4662-b05d-145040ca74b3
if ! grep -q ${disk_uuid} /etc/fstab; then
    echo '' >> /etc/fstab
    echo '# hd0 ext4 datastore' >> /etc/fstab
    echo "UUID=${disk_uuid}		/data/hd0/p2	auto 	defaults	0	1" >> /etc/fstab
else
    echo 'skipping hd0 ext4 datastore 2.'
fi

# mkdir -p /data/sd0/p0
# mount UUID="BEE60E9EE60E56D5" /data/sd0/p0
mkdir -p /data/sd0/p0
disk_uuid=BEE60E9EE60E56D5
if ! grep -q ${disk_uuid} /etc/fstab; then
    echo '' >> /etc/fstab
    echo '# sd0 ntfs + windows partition' >> /etc/fstab
    echo "UUID=${disk_uuid} 	/data/sd0/p0	auto 	defaults	0	1" >> /etc/fstab
else
    echo 'skipping sd0 ntfs datastore.'
fi

# UBUNTU PARTITION
# mkdir -p /data/sd0/p1
# mount UUID="07b8854c-37ee-43c8-9eef-44331efaa76d" /data/sd0/p1

mkdir -p /data/sd0/here


mount -a
