apt install nova-compute

# novapass placementpass MANAGEMENT_INTERFACE_IP_ADDRESS

Crudini --set /etc/nova/nova.conf DEFAULT transport_url rabbit://openstack:RABBIT_PASS@controller 
Crudini --set /etc/nova/nova.conf DEFAULT my_ip $3 

Crudini --set /etc/nova/nova.conf api auth_strategy keystone 

Crudini --set /etc/nova/nova.conf keystone_authtoken www_authenticate_uri http://controller:5000/ 
Crudini --set /etc/nova/nova.conf keystone_authtoken auth_url http://controller:5000/ 
Crudini --set /etc/nova/nova.conf keystone_authtoken memcached_servers controller:11211 
Crudini --set /etc/nova/nova.conf keystone_authtoken auth_type password 
Crudini --set /etc/nova/nova.conf keystone_authtoken project_domain_name Default 
Crudini --set /etc/nova/nova.conf keystone_authtoken user_domain_name Default 
Crudini --set /etc/nova/nova.conf keystone_authtoken project_name service 
Crudini --set /etc/nova/nova.conf keystone_authtoken username nova 
Crudini --set /etc/nova/nova.conf keystone_authtoken password $1 

Crudini --set /etc/nova/nova.conf service_user send_service_user_token true 
Crudini --set /etc/nova/nova.conf service_user auth_url https://controller/identity 
Crudini --set /etc/nova/nova.conf service_user auth_strategy keystone 
Crudini --set /etc/nova/nova.conf service_user auth_type password 
Crudini --set /etc/nova/nova.conf service_user project_domain_name Default 
Crudini --set /etc/nova/nova.conf service_user project_name service 
Crudini --set /etc/nova/nova.conf service_user user_domain_name Default 
Crudini --set /etc/nova/nova.conf service_user username nova 
Crudini --set /etc/nova/nova.conf service_user password $1 

Crudini --set /etc/nova/nova.conf vnc enabled true 
Crudini --set /etc/nova/nova.conf vnc server_listen 0.0.0.0 
Crudini --set /etc/nova/nova.conf vnc server_proxyclient_address $my_ip 
Crudini --set /etc/nova/nova.conf vnc novncproxy_base_url http://controller:6080/vnc_auto.html 

Crudini --set /etc/nova/nova.conf glance api_servers http://controller:9292 

Crudini --set /etc/nova/nova.conf oslo_concurrency lock_path /var/lib/nova/tmp 

Crudini --set /etc/nova/nova.conf placement region_name RegionOne 
Crudini --set /etc/nova/nova.conf placement project_domain_name Default 
Crudini --set /etc/nova/nova.conf placement project_name service 
Crudini --set /etc/nova/nova.conf placement auth_type password 
Crudini --set /etc/nova/nova.conf placement user_domain_name Default 
Crudini --set /etc/nova/nova.conf placement auth_url http://controller:5000/v3 
Crudini --set /etc/nova/nova.conf placement username placement 
Crudini --set /etc/nova/nova.conf placement password $2 

Crudini --set /etc/nova/nova.conf scheduler discover_hosts_in_cells_interval 300 
