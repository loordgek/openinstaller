#!/bin/bash

apt install lvm2 thin-provisioning-tools
pvcreate /dev/sdb
vgcreate cinder-volumes /dev/sdb
apt install cinder-volume tgt

Crudini --set /etc/cinder/cinder.conf database connection mysql+pymysql://cinder:CINDER_DBPASS@controller/cinder 
Crudini --set /etc/cinder/cinder.conf DEFAULT transport_url rabbit://openstack:RABBIT_PASS@controller 
Crudini --set /etc/cinder/cinder.conf DEFAULT auth_strategy keystone 
Crudini --set /etc/cinder/cinder.conf DEFAULT enabled_backends lvm 
Crudini --set /etc/cinder/cinder.conf DEFAULT my_ip MANAGEMENT_INTERFACE_IP_ADDRESS 
Crudini --set /etc/cinder/cinder.conf DEFAULT glance_api_servers http://controller:9292 
Crudini --set /etc/cinder/cinder.conf keystone_authtoken www_authenticate_uri http://controller:5000 
Crudini --set /etc/cinder/cinder.conf keystone_authtoken auth_url http://controller:5000 
Crudini --set /etc/cinder/cinder.conf keystone_authtoken memcached_servers controller:11211 
Crudini --set /etc/cinder/cinder.conf keystone_authtoken auth_type password 
Crudini --set /etc/cinder/cinder.conf keystone_authtoken project_domain_name default 
Crudini --set /etc/cinder/cinder.conf keystone_authtoken user_domain_name default 
Crudini --set /etc/cinder/cinder.conf keystone_authtoken project_name service 
Crudini --set /etc/cinder/cinder.conf keystone_authtoken username cinder 
Crudini --set /etc/cinder/cinder.conf keystone_authtoken password CINDER_PASS 
Crudini --set /etc/cinder/cinder.conf lvm volume_driver cinder.volume.drivers.lvm.LVMVolumeDriver 
Crudini --set /etc/cinder/cinder.conf lvm volume_group cinder-volumes 
Crudini --set /etc/cinder/cinder.conf lvm target_protocol iscsi 
Crudini --set /etc/cinder/cinder.conf lvm target_helper tgtadm 
Crudini --set /etc/cinder/cinder.conf oslo_concurrency lock_path /var/lib/cinder/tmp 

#Perform this step only when using tgt target.
touch /etc/tgt/conf.d/cinder.conf

# Define the file you want to edit
file_to_edit="/etc/tgt/conf.d/cinder.conf"

# Use `sed` to edit the file
# In this example, we replace a specific line with new content
# You can adjust this line to match your specific editing requirements
sed -i 's//include /var/lib/cinder/volumes/*/' "$file_to_edit"


service tgt restart

service cinder-volume restart
