# Vault FTP Server

This project contains the code for setting up an FTP server at Amazon AWS to power
ftp.vault.venuedriver.com.  This FTP server is for accepting data files from some
data sources.  The first use case for this server was to accept periodic data dumps
from OpenTable.

## Technology

The goal was to get [vsftp](http://vsftpd.beasts.org/) running in the cloud.  Modern
system administrators don't set up things like that by hand, they use DevOps.  The
cloud server should be the product of code, not a human's manual labor.  To accomplish
that, I used [Vagrant](https://www.vagrantup.com/) to create an
[Ubuntu 12.04](http://releases.ubuntu.com/12.04/) cloud instance at
[Amazon EC2](http://aws.amazon.com/ec2/).  I used [Chef](http://www.getchef.com/chef/)
to provision the instance with vsftp, to configure it, and to create the FTP user(s).

## Authentication

To spin up an EC2 machine you'll need a key and secret for accessing your AWS account.
Create an IAM user in a group with full access to EC2, and provide the key and secret
by setting two environment variables:

    export AWS_KEY=“[YOUR KEY]"
    export AWS_SECRET="[YOUR SECRET]”

To access the EC2 machine you'll need an [EC2 key pair](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-key-pairs.html).  If you have a key pair in a file
called ```vault-ftp.pem``` in the root of this project, then you can configure that
by setting two environment variables, like this:

    export AWS_KEYPAIR_NAME="vault-ftp”
    export AWS_KEYPAIR_PATH="vault-ftp.pem"

## Users

You also need to provide a ```users.yml``` file in the root of this project that contains
a list of users to set up on the server.  You can change this file and then re-provision
with Chef, using ```vagrant provision``` to make changes to the user list.

The format of the file is:

    username:
      password: 'password'
      shadow_hash: 'shadow_hash'

For example, if there are two users, ```foo``` and ```bar```, with the passwords ```password1```
and ```password2``` respectively, then the file should look like this:

    foo:
      password: 'password1'
      shadow_hash: '$1$yoursalt$u/huh9HuopXpub4Ha3SWO/'
    bar:
      password: 'password2'
      shadow_hash: '$1$yoursalt$AWgHV/EkLFgEsWORPVSjh.'

The ```password:``` entries are really just there for your benefit.  If you're storing them
somewhere more secure then they're not necessary.

Generate the shadow hashes with:

    openssl passwd -1 -salt "yoursaltphrase"

Use any salt phrase you like.

## Ports

You will need to adjust your default security group (or specify a custom group) to open ports
for:

* FTP (port 21)
* SSH/SFTP (port 22)

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