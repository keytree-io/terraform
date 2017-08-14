##################################################################################################
#
#       SCRIPT NAME: Setup Hostname / IP Address (and updated fstab)
#       EXECUTION INSTRUCTIONS:  
#       VARIABLES: userdata
#       VERSION:  1.8
#       AUTHOR:  Keytree Ltd
#       REVISIONS: 
#
##################################################################################################
# Definition of IP Address / Hostname Assignment
##################################################################################################

sudo /bin/su -c 'hostname suse-hana.keytree.io'
sudo /bin/su -c 'echo "suse-hana.keytree.io" > /etc/hostname'
sudo /bin/su -c 'echo `curl ifconfig.me` suse-hana.keytree.io suse-hana  >> /etc/hosts'
sudo /bin/su -c 'mkdir -p /backup /_backup /usr/sap /sapmnt /hana /hana/log /hana/data /usr/sap/trans'
sudo /bin/su -c 'echo "#####################################################################################################" >> /etc/fstab'
sudo /bin/su -c 'echo "# SAP Mounts                                                                                        #" >> /etc/fstab'
sudo /bin/su -c 'echo "#####################################################################################################" >> /etc/fstab'
sudo /bin/su -c 'echo "#/dev/vg_sap0/lv_sap_swap swap swap defaults 0 0" >> /etc/fstab'
sudo /bin/su -c 'echo "/dev/vg_sap0/lv_sap_usrsap /usr/sap xfs nobarrier,noatime,nodiratime,logbsize=256k 0 0" >> /etc/fstab'
sudo /bin/su -c 'echo "/dev/vg_sap0/lv_sap_sapmnt /sapmnt xfs nobarrier,noatime,nodiratime,logbsize=256k 0 0" >> /etc/fstab'
sudo /bin/su -c 'echo "/dev/vg_sap0/lv_sap_backup /backup xfs nobarrier,noatime,nodiratime,logbsize=256k 0 0" >> /etc/fstab'
sudo /bin/su -c 'echo "/dev/vg_sap0/lv_sap_hana /hana xfs nobarrier,noatime,nodiratime,logbsize=256k 0 0" >> /etc/fstab'
sudo /bin/su -c 'echo "/dev/vg_hana0/lv_sap_hanadata /hana/data xfs nobarrier,noatime,nodiratime,logbsize=256k 0 0" >> /etc/fstab'
sudo /bin/su -c 'echo "/dev/vg_hana0/lv_sap_hanalog /hana/log xfs nobarrier,noatime,nodiratime,logbsize=256k 0 0" >> /etc/fstab'
sudo /bin/su -c 'echo "#####################################################################################################" >> /etc/fstab'
