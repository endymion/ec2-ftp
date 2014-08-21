package "vsftpd"

cookbook_file "vsftpd.conf" do
  path "/etc/vsftpd.conf"
end

execute "restart vsftpd" do
  user "root"
  command "service vsftpd restart"
end

# Load users from users.yaml file in the root of the project.
require 'yaml'
ftp_users = YAML.load_file('/vagrant/users.yml').each do |ftp_user|
  username = ftp_user[0]
  user username do
    password ftp_user[1]['shadow_hash']
    home "/home/#{username}"
    supports :manage_home=>true
  end
  directory "/home/#{username}" do
    owner username
    mode 0444
    action :create
  end
end