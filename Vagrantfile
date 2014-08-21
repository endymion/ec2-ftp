Vagrant.configure("2") do |config|
  config.vm.box = "dummy"
  config.vm.box_url = "https://github.com/mitchellh/vagrant-aws/raw/master/dummy.box"

  config.vm.provider :aws do |aws, override|
    aws.ami = "ami-0e5b5f4b"
    aws.access_key_id = ENV['AWS_KEY']
    aws.secret_access_key = ENV['AWS_SECRET']
    aws.keypair_name = ENV['AWS_KEYPAIR_NAME']
    override.ssh.private_key_path = ENV['AWS_KEYPAIR_PATH']
    override.ssh.username = "ubuntu"
    aws.instance_ready_timeout = 300

    aws.region = "us-west-1"
    aws.instance_type = "t2.micro"
    aws.block_device_mapping = [{ 'DeviceName' => '/dev/sda1', 'Ebs.VolumeSize' => 100 }]
  end

  # Ensures that Chef is installed, using the Vagrant Omnibus plugin.
  config.omnibus.chef_version = :latest

  config.vm.provision :shell, :inline => "apt-get update --fix-missing -y"
  config.vm.provision :chef_solo do |chef|
    chef.cookbooks_path = "cookbooks/development"
    chef.log_level = :debug
    chef.add_recipe "configure"
  end

end