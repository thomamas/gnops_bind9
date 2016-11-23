#
# Cookbook Name:: gnops_bind9
# Recipe:: default
#
# Copyright (C) 2016 Gracenote
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

Chef::Log.warn('The gnops_bind9 cookbook has only been tested with Debian.') \
  unless platform_family?('debian')

package 'bind9' do
  case node['platform_family']
  when 'rhel'
    package_name 'bind'
  when 'debian'
    package_name 'bind9'
  end
  action :install
end

# named.conf

template '/etc/bind/named.conf' do
  source 'named.conf.erb'
  action :create
  mode '644'
  owner 'root'
  group 'bind'
  notifies :reload, 'service[bind9]', :delayed
end

template '/etc/bind/named.conf.logging' do
  source 'named.conf.logging.erb'
  mode '644'
  owner 'root'
  group 'bind'
end

template '/etc/bind/named.conf.local' do
  source 'named.conf.local.erb'
  action :create
  mode '644'
  owner 'root'
  group 'bind'
  notifies :restart, 'service[bind9]', :delayed
  variables(
    data: node['gnops']['bind9']['groups']
  )
end

template '/etc/bind/named.conf.options' do
  source 'named.conf.options.erb'
  action :create
  mode '644'
  owner 'root'
  group 'bind'
  variables(
    fwd: node['gnops']['bind9']['forward_default'],
    fwd_upstream: node['gnops']['bind9']['forward_upstream'],
    internal: node['gnops']['bind9']['internal_nets']
  )
  notifies :restart, 'service[bind9]', :delayed
end

# defaults

template '/etc/default/bind9' do
  source 'default.bind9.erb'
  mode '644'
  owner 'root'
  group 'root'
  variables(
    ipv4_only: node['gnops']['bind9']['ipv4_only']
  )
  notifies :restart, 'service[bind9]', :delayed
end

# log directory

directory '/var/log/named' do
  mode '755'
  owner 'bind'
  group 'bind'
end

# start the service

service 'bind9' do
  supports status: true, reload: true, restart: true
  action [:enable, :start]
  if node['init_package'] == 'systemd'
    ignore_failure true
    # At least in Ubuntu 16.04, systemd shows a bogus error on restart during
    # first convergence.
  end
end
