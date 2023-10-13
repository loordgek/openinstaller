#!/bin/bash

# shellcheck source=util.sh
# shellcheck source=admin-openrc.sh

source util.sh
source admin-openrc.sh


password=$(GeneratePassWord)

makeDB nova_api   nova "$password"
makeDB nova       nova "$password"
makeDB nova_cell0 nova "$password"

openstack user create --domain default --password-prompt nova
openstack role add --project service --user nova admin
openstack service create --name nova --description "OpenStack Compute" compute

openstack endpoint create --region RegionOne compute public http://controller:8774/v2.1
openstack endpoint create --region RegionOne compute internal http://controller:8774/v2.1
openstack endpoint create --region RegionOne compute admin http://controller:8774/v2.1

apt install nova-api nova-conductor nova-novncproxy nova-scheduler

Crudini --set /etc/nova/nova.conf api_database connection mysql+pymysql://nova:"$password"@controller/nova_api 

Crudini --set /etc/nova/nova.conf database connection mysql+pymysql://nova:"$password"@controller/nova 

Crudini --set /etc/nova/nova.conf DEFAULT my_ip 10.0.0.11 
Crudini --set /etc/nova/nova.conf DEFAULT transport_url rabbit://openstack:RABBIT_PASS@controller:5672/ 

Crudini --set /etc/nova/nova.conf api auth_strategy keystone 

Crudini --set /etc/nova/nova.conf keystone_authtoken www_authenticate_uri http://controller:5000/ 
Crudini --set /etc/nova/nova.conf keystone_authtoken auth_url http://controller:5000/ 
Crudini --set /etc/nova/nova.conf keystone_authtoken memcached_servers controller:11211 
Crudini --set /etc/nova/nova.conf keystone_authtoken auth_type password 
Crudini --set /etc/nova/nova.conf keystone_authtoken project_domain_name Default 
Crudini --set /etc/nova/nova.conf keystone_authtoken user_domain_name Default 
Crudini --set /etc/nova/nova.conf keystone_authtoken project_name service 
Crudini --set /etc/nova/nova.conf keystone_authtoken username nova 
Crudini --set /etc/nova/nova.conf keystone_authtoken password NOVA_PASS 

Crudini --set /etc/nova/nova.conf service_user send_service_user_token true 
Crudini --set /etc/nova/nova.conf service_user auth_url https://controller/identity 
Crudini --set /etc/nova/nova.conf service_user auth_strategy keystone 
Crudini --set /etc/nova/nova.conf service_user auth_type password 
Crudini --set /etc/nova/nova.conf service_user project_domain_name Default 
Crudini --set /etc/nova/nova.conf service_user project_name service 
Crudini --set /etc/nova/nova.conf service_user user_domain_name Default 
Crudini --set /etc/nova/nova.conf service_user username nova 
Crudini --set /etc/nova/nova.conf service_user password NOVA_PASS 

Crudini --set /etc/nova/nova.conf vnc enabled true 
Crudini --set /etc/nova/nova.conf vnc server_listen $my_ip 
Crudini --set /etc/nova/nova.conf vnc server_proxyclient_address $my_ip 

Crudini --set /etc/nova/nova.conf glance api_servers http://controller:9292 

Crudini --set /etc/nova/nova.conf oslo_concurrency lock_path /var/lib/nova/tmp 

Crudini --del /etc/nova/nova.conf placement

Crudini --set /etc/nova/nova.conf placement region_name RegionOne 
Crudini --set /etc/nova/nova.conf placement project_domain_name Default 
Crudini --set /etc/nova/nova.conf placement project_name service 
Crudini --set /etc/nova/nova.conf placement auth_type password 
Crudini --set /etc/nova/nova.conf placement user_domain_name Default 
Crudini --set /etc/nova/nova.conf placement auth_url http://controller:5000/v3 
Crudini --set /etc/nova/nova.conf placement username placement 
Crudini --set /etc/nova/nova.conf placement password PLACEMENT_PASS 

su -s /bin/sh -c "nova-manage api_db sync" nova
su -s /bin/sh -c "nova-manage cell_v2 map_cell0" nova
su -s /bin/sh -c "nova-manage cell_v2 create_cell --name=cell1 --verbose" nova
su -s /bin/sh -c "nova-manage db sync" nova

service nova-api restart
service nova-scheduler restart
service nova-conductor restart
service nova-novncproxy restart
