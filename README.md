# Vault FTP Server

This project contains the code for setting up an FTP server at Amazon AWS to power
ftp.vault.venuedriver.com.  This FTP server is for accepting data files from some
data sources.  The first use case for this server was to accept periodic data dumps
from OpenTable.

## Setup

* Install [Git](http://git-scm.com/)
* Install [VirtualBox](https://www.virtualbox.org)
* Install [Vagrant](http://downloads.vagrantup.com/)
* Install the Vagrant-Omnibus plugin for Vagrant: ```vagrant plugin install vagrant-omnibus```
* Clone the project to your development system by opening a terminal and switching to the
folder on your machine where you want the code (suggestion: ```cd ~/projects```) and enter
this command: ```git clone git@github.com:VenueDriver/vault-ftp.git```.  If you can
```cd vault-ftp``` then it worked.
* Spin up your Vagrant virtual machine in AWS with ```vagrant up --provision=aws```.  Vagrant will automatically use the specified AMI to create a new cloud instance, and then
provision (configure) the instance using Chef.