#!/bin/bash
source util.sh
source admin-openrc.sh

password=$(GeneratePassWord)

makeDB cinder cinder "$password"

openstack user create --domain default --password-prompt cinder
openstack role add --project service --user cinder admin

openstack service create --name cinderv3 --description "OpenStack Block Storage" volumev3

openstack endpoint create --region RegionOne volumev3 public http://controller:8776/v3/%\(project_id\)s

openstack endpoint create --region RegionOne volumev3 internal http://controller:8776/v3/%\(project_id\)s

openstack endpoint create --region RegionOne volumev3 admin http://controller:8776/v3/%\(project_id\)s

apt install cinder-api cinder-scheduler

Crudini --set /etc/cinder/cinder.conf database connection mysql+pymysql://cinder:CINDER_DBPASS@controller/cinder

Crudini --set /etc/cinder/cinder.conf DEFAULT transport_url rabbit://openstack:RABBIT_PASS@controller 
Crudini --set /etc/cinder/cinder.conf DEFAULT auth_strategy keystone 
Crudini --set /etc/cinder/cinder.conf DEFAULT my_ip 10.0.0.11 

Crudini --del /etc/cinder/cinder.conf keystone_authtoken

Crudini --set /etc/cinder/cinder.conf keystone_authtoken www_authenticate_uri http://controller:5000 
Crudini --set /etc/cinder/cinder.conf keystone_authtoken auth_url http://controller:5000 
Crudini --set /etc/cinder/cinder.conf keystone_authtoken memcached_servers controller:11211 
Crudini --set /etc/cinder/cinder.conf keystone_authtoken auth_type password 
Crudini --set /etc/cinder/cinder.conf keystone_authtoken project_domain_name default 
Crudini --set /etc/cinder/cinder.conf keystone_authtoken user_domain_name default 
Crudini --set /etc/cinder/cinder.conf keystone_authtoken project_name service 
Crudini --set /etc/cinder/cinder.conf keystone_authtoken username cinder 
Crudini --set /etc/cinder/cinder.conf keystone_authtoken password CINDER_PASS 

Crudini --set /etc/cinder/cinder.conf oslo_concurrency lock_path /var/lib/cinder/tmp 

su -s /bin/sh -c "cinder-manage db sync" cinder

service nova-api restart

service cinder-scheduler restart

service apache2 restart

