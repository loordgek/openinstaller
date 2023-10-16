#!/bin/bash

source util.sh
source admin-openrc.sh

password=$(GeneratePassWord)

makeDB neutron neutron "$password"

openstack user create --domain default --password-prompt neutron
openstack role add --project service --user neutron admin

openstack service create --name neutron --description "OpenStack Networking" network

openstack endpoint create --region RegionOne network public http://controller:9696
openstack endpoint create --region RegionOne network internal http://controller:9696
openstack endpoint create --region RegionOne network admin http://controller:9696

Provider-networks.sh

Crudini --set /etc/neutron/metadata_agent.ini DEFAULT nova_metadata_host controller 
Crudini --set /etc/neutron/metadata_agent.ini DEFAULT metadata_proxy_shared_secret METADATA_SECRET 

service neutron-server restart

service neutron-openvswitch-agent restart

service neutron-dhcp-agent restart

service neutron-metadata-agent restart