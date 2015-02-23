#
# Cookbook Name:: cldemo_base
# Recipe:: users
#
# Copyright 2014, Cumulus Networks
#


node["cldemo"]["users"].each_with_index do |login,index|
	user login do
		comment     "#{login.capitalize} user"
		uid         600+index
		password    "$1$mKzk5zJc$rjQIr24v.ZF27J7TAaZxQ."
		home        "/home/#{login}"
		supports    :manage_home => true
		shell       "/bin/bash"
	end
	directory "/home/#{login}/.ssh" do
		owner login
		group login
		mode  0750
	end
	template "/home/#{login}/.ssh/authorized_keys" do
		source "authorized_keys.erb"
		mode   0400
		owner  login
		group  login
		variables({
			:ssh_keys => [ "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCs0iscDeejPmguBLIKoes6bZrxIq89mW4dfeox9Bhel1qqDVJZjeqgj6MaI53WnNHcLZFzNyIL4wzNvTL9dVIgc3hHissiieFvtK71q9xqbxwYbySq+yKxJMTe+MrbyLpj5XZVDL/E8/xVxP+YIXMpHm9GeMVeyAT/fPRgkXHGWoHsBz7bGJQi6s78NU0gjtIuT2h+mKhSo2ZZrDNjqR11x5AVjZLB304Y3UxNCsuTjozNNu5JqjW2+9QhKWHLI3kUWUz9EjCV77KKS0GbevQo7Mx8D7uQT3IQxbm3UBhK88GnZeRzkP4ULZ5uYkY1D3hiuSAirDBTdT2lHc/iTX7R Demo key" ]
			})
	end
	template "/etc/sudoers.d/#{login}" do
		source "sudo.erb"
		owner "root"
		group "root"
		mode  "0440"
		variables({
			:user       => login,
			:privileges => ["ALL = (root) NOPASSWD: ALL"]
			})
	end
end

node["cldemo"]["groups"].each do |group|
	group group do
		append      true
		members     node["cldemo"]["users"]
	end
end
