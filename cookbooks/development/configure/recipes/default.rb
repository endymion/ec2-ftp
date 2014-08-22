package "vsftpd"

cookbook_file "vsftpd.conf" do
  path "/etc/vsftpd.conf"
end

execute "create SSL certificate for SFTP" do
  user "root"
  command "openssl req -x509 -nodes -days 3650 -newkey rsa:1024 -subj '/C=US/ST=Nevada/L=Las Vegas/O=HakkasanGroup/CN=ftp.vault.venuedriver.com' -keyout /etc/ssl/private/vsftpd.pem -out /etc/ssl/private/vsftpd.pem"
  not_if { ::File.exists?('/etc/ssl/private/vsftpd.pem')}
end

execute "Configure sshd - allow password" do
  user "root"
  command <<-EOF
  sed -i 's/^.*PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config
  EOF
  only_if "egrep 'PasswordAuthentication no' /etc/ssh/sshd_config"
end

execute "restart sshd" do
  user "root"
  command "service ssh restart"
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
    mode 0500
    action :create
  end
end