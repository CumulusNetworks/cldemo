#
# Cookbook Name:: portsconf
# Recipe:: default
#
# Copyright 2015, Cumulus Networks
#
# All rights reserved - Do Not Redistribute
#

cookbook_file '40G.conf' do
  path '/etc/cumulus/ports.conf'
  owner 'root'
  group 'root'
  mode '0644'
  action :create
  notifies :restart, "service[switchd]"
end
