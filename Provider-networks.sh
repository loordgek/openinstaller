#!/bin/bash

# shellcheck source=util.sh
# shellcheck source=admin-openrc.sh

source util.sh
source admin-openrc.sh

apt install neutron-server neutron-plugin-ml2 neutron-openvswitch-agent neutron-dhcp-agent neutron-metadata-agent

Crudini --set /etc/neutron/neutron.conf database connection mysql+pymysql://neutron:NEUTRON_DBPASS@controller/neutron 
Crudini --set /etc/neutron/neutron.conf DEFAULT core_plugin ml2 
Crudini --set /etc/neutron/neutron.conf DEFAULT transport_url rabbit://openstack:RABBIT_PASS@controller 
Crudini --set /etc/neutron/neutron.conf DEFAULT auth_strategy keystone 
Crudini --set /etc/neutron/neutron.conf DEFAULT notify_nova_on_port_status_changes true 
Crudini --set /etc/neutron/neutron.conf DEFAULT notify_nova_on_port_data_changes true 
Crudini --set /etc/neutron/neutron.conf keystone_authtoken www_authenticate_uri http://controller:5000 
Crudini --set /etc/neutron/neutron.conf keystone_authtoken auth_url http://controller:5000 
Crudini --set /etc/neutron/neutron.conf keystone_authtoken memcached_servers controller:11211 
Crudini --set /etc/neutron/neutron.conf keystone_authtoken auth_type password 
Crudini --set /etc/neutron/neutron.conf keystone_authtoken project_domain_name Default 
Crudini --set /etc/neutron/neutron.conf keystone_authtoken user_domain_name Default 
Crudini --set /etc/neutron/neutron.conf keystone_authtoken project_name service 
Crudini --set /etc/neutron/neutron.conf keystone_authtoken username neutron 
Crudini --set /etc/neutron/neutron.conf keystone_authtoken password NEUTRON_PASS 
Crudini --set /etc/neutron/neutron.conf nova auth_url http://controller:5000 
Crudini --set /etc/neutron/neutron.conf nova auth_type password 
Crudini --set /etc/neutron/neutron.conf nova project_domain_name Default 
Crudini --set /etc/neutron/neutron.conf nova user_domain_name Default 
Crudini --set /etc/neutron/neutron.conf nova region_name RegionOne 
Crudini --set /etc/neutron/neutron.conf nova project_name service 
Crudini --set /etc/neutron/neutron.conf nova username nova 
Crudini --set /etc/neutron/neutron.conf nova password NOVA_PASS 
Crudini --set /etc/neutron/neutron.conf oslo_concurrency lock_path /var/lib/neutron/tmp 

Crudini --set /etc/neutron/plugins/ml2/ml2_conf.ini ml2 type_drivers flat,vlan 
Crudini --set /etc/neutron/plugins/ml2/ml2_conf.ini ml2 tenant_network_types "" 
Crudini --set /etc/neutron/plugins/ml2/ml2_conf.ini ml2 mechanism_drivers openvswitch 
Crudini --set /etc/neutron/plugins/ml2/ml2_conf.ini ml2 extension_drivers port_security 
Crudini --set /etc/neutron/plugins/ml2/ml2_conf.ini ml2_type_flat flat_networks provider 

#Replace PROVIDER_INTERFACE_NAME with the name of the underlying provider physical network interface. See Host networking for more information.
Crudini --set /etc/neutron/plugins/ml2/openvswitch_agent.ini ovs bridge_mappings provider:PROVIDER_INTERFACE_NAME 
Crudini --set /etc/neutron/plugins/ml2/openvswitch_agent.ini securitygroup enable_security_group true 
Crudini --set /etc/neutron/plugins/ml2/openvswitch_agent.ini securitygroup firewall_driver openvswitch 

Crudini --set /etc/neutron/dhcp_agent.ini DEFAULT interface_driver openvswitch 
Crudini --set /etc/neutron/dhcp_agent.ini DEFAULT dhcp_driver neutron.agent.linux.dhcp.Dnsmasq 
Crudini --set /etc/neutron/dhcp_agent.ini DEFAULT enable_isolated_metadata true 

