#!/bin/bash
# Set Hostname and IP Address (CHEF needs FQDN)
hostname hana02.keytree.io
sed -i "s/HOSTNAME=.*/HOSTNAME=hana02.keytree.io/g" /etc/sysconfig/network
echo `hostname -I` hana02.keytree.io hana02  >> /etc/hosts

# Disable SELinux, Other Services and Update TZ
perl -i -pe 's/enforcing/disabled/g' /etc/selinux/config
service ip6tables stop && chkconfig ip6tables off
echo ZONE='"UTC"' > /etc/sysconfig/clock && tzdata-update && service ntpd start && chkconfig ntpd on
service cups stop && chkconfig cups off
groupadd sapsys

# Get XFS Installed
rpm -ivh http://mirror.centos.org/centos/6/os/x86_64/Packages/xfsprogs-3.1.1-20.el6.x86_64.rpm
rpm -ivh http://mirror.centos.org/centos/6/os/x86_64/Packages/xfsdump-3.0.4-4.el6_6.1.x86_64.rpm

echo "noop" > /sys/block/xvdb/queue/scheduler
echo "noop" > /sys/block/xvdc/queue/scheduler
echo "noop" > /sys/block/xvdd/queue/scheduler
echo "noop" > /sys/block/xvde/queue/scheduler
#echo "noop" > /sys/block/xvdf/queue/scheduler
#echo "noop" > /sys/block/xvdg/queue/scheduler
#echo "noop" > /sys/block/xvdh/queue/scheduler
#echo "noop" > /sys/block/xvdi/queue/scheduler
#echo "noop" > /sys/block/xvdj/queue/scheduler
#echo "noop" > /sys/block/xvdk/queue/scheduler
#echo "noop" > /sys/block/xvdl/queue/scheduler
#echo "noop" > /sys/block/xvdm/queue/scheduler
#echo "noop" > /sys/block/xvdn/queue/scheduler
#echo "noop" > /sys/block/xvdo/queue/scheduler
#echo "noop" > /sys/block/xvdp/queue/scheduler

# Build VGs, LVs and Filesystems
yum install lvm2 -y ; sleep 100; 
pvcreate /dev/xvdb /dev/xvdc /dev/xvdd /dev/xvde /dev/xvdf /dev/xvdg /dev/xvdh 
vgcreate vg_sap0 /dev/xvdb /dev/xvdc /dev/xvdd /dev/xvde /dev/xvdf 
vgcreate vg_hana0 /dev/xvdg /dev/xvdh 
lvcreate -n lv_sap_usrsap -L 1G vg_sap0 && lvcreate -n lv_sapmnt -L 1G vg_sap0 && lvcreate -n lv_backup -L 1G vg_sap0 && lvcreate -n lv_sap_hana -L 1G vg_sap0 
lvcreate -n lv_sap_hanadata -L 1G vg_hana0 && lvcreate -n lv_sap_hanalog -L 1G vg_hana0

for i in `lvdisplay |grep Path| awk '{print $3}'`; do mkfs.xfs $i; done
mkdir -p /backup /_backup /usr/sap /sapmnt /hana /hana/log /hana/data /usr/sap/trans

echo "#####################################################################################################" >> /etc/fstab
echo "# SAP Mounts                                                                                        #" >> /etc/fstab
echo "#####################################################################################################" >> /etc/fstab
echo "#/dev/vg_sap0/lv_sap_swap swap swap defaults 0 0" >> /etc/fstab
echo "/dev/vg_sap0/lv_sap_usrsap /usr/sap xfs nobarrier,noatime,nodiratime,logbsize=256k,delaylog 0 0" >> /etc/fstab
echo "/dev/vg_sap0/lv_sap_sapmnt /sapmnt xfs nobarrier,noatime,nodiratime,logbsize=256k,delaylog 0 0" >> /etc/fstab
echo "/dev/vg_sap0/lv_sap_backup /backup xfs nobarrier,noatime,nodiratime,logbsize=256k,delaylog 0 0" >> /etc/fstab
echo "/dev/vg_sap0/lv_sap_hana /hana xfs nobarrier,noatime,nodiratime,logbsize=256k,delaylog 0 0" >> /etc/fstab
echo "/dev/vg_hana0/lv_sap_hanadata /hana/data xfs nobarrier,noatime,nodiratime,logbsize=256k,delaylog 0 0" >> /etc/fstab
echo "/dev/vg_hana0/lv_sap_hanalog /hana/log xfs nobarrier,noatime,nodiratime,logbsize=256k,delaylog 0 0" >> /etc/fstab
echo "#####################################################################################################" >> /etc/fstab
mount -a
swapon -va


##  pvcreate /dev/xvdb /dev/xvdc /dev/xvdd /dev/xvde /dev/xvdf /dev/xvdg /dev/xvdh /dev/xvdi /dev/xvdj /dev/xvdk /dev/xvdl /dev/xvdm /dev/xvdn /dev/xvdo /dev/xvdp
##  vgcreate vg_sap0 /dev/xvdb /dev/xvdc /dev/xvdd /dev/xvde /dev/xvdf
##  vgcreate vg_hana0 /dev/xvdg /dev/xvdh /dev/xvdi /dev/xvdj /dev/xvdk /dev/xvdl /dev/xvdm /dev/xvdn /dev/xvdo /dev/xvdp
##  lvcreate -n lv_sap_sapmnt -i 5 -I 256 -L 20G vg_sap0
##  lvcreate -n lv_sap_usrsap -i 5 -I 256 -L 30G vg_sap0
##  lvcreate -n lv_sap_hana -i 5 -I 256 -L 50G vg_sap0
##  lvcreate -n lv_sap_backup -i 5 -I 256 -L 300G vg_sap0
##  lvcreate -n lv_sap_hanadata -i 10 -I 256 -L 150G vg_hana0
##  lvcreate -n lv_sap_hanalog -i 10 -I 256 -L 70G vg_hana0
##  lvcreate -n lv_sap_swap -i 5 -I 256 -L 100G vg_sap0
##  mkswap /dev/vg_sap0/lv_sap_swap

