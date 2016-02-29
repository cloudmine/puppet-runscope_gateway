# coding: utf-8
module_name = 'runscope_gateway'

Vagrant.configure("2") do |config|
  config.r10k.puppet_dir = "."
  config.r10k.puppetfile_path = "Puppetfile"

  config.vm.synced_folder "~/.aws", "/root/.aws",
    create: true,
    owner: "root",
    group: "root"

  # This is just bootstrapping a virtualbox instance.
  config.vm.define :ubuntu1404 do |ubuntu1404|
    ubuntu1404.vm.box         = 'puppetlabs/ubuntu-14.04-64-puppet'
    ubuntu1404.vm.box_version =  '1.0.1'
    ubuntu1404.vm.hostname    = "#{module_name.tr '_', '-'}-ubuntu-1404"
  end

  # This is a place holder image declaration for an aws 'box' image.
  #config.vm.define :dummy do |dummy|
  #  dummy.vm.box         = 'dummy'
  #  dummy.vm.box_version =  '0'
  #  dummy.vm.hostname    = "#{module_name.tr '_', '-'}-ubuntu-aws"
  #end

  # Virtualbox
  config.vm.network :private_network, ip: '192.168.50.10'
  config.vm.network "forwarded_port", guest: 8000, host: 8000

  config.vm.provider "virtualbox" do |v|
    v.customize [
      "modifyvm", :id,
      "--memory", 1024,
      "--cpus", 1
    ]
  end

  config.vm.provider "vmware_fusion" do |v|
    v.vmx["memsize"] = "1024"
    v.vmx["numvcpus"] = "1"
  end

  #config.vm.provider :aws do |aws, override|
  #  aws.access_key_id              = config.user.aws.access_key
  #  aws.secret_access_key          = config.user.aws.secret_key
  #  aws.keypair_name               = config.user.aws.keypair_name
  #  aws.ami                        = "ami-"
  #  aws.region                     = "us-east-1"
  #  aws.instance_type              = "m3.medium"
  #  aws.availability_zone          = 'us-east-1e'
  #  aws.subnet_id                  = "subnet-"
  #  aws.instance_ready_timeout     = 300
  #  aws.ssh_host_attribute         = :private_ip_address
  #  aws.security_groups            = ["sg-"]
  #  aws.tags                       = { 'Name' => 'vagrant-box'}
  #  aws.iam_instance_profile_arn   = "arn:aws:iam::ACCOUNT_NUMBER:instance-profile/ROLE_NAME"
  #  override.vm.box                = "dummy"
  #  override.ssh.username          = config.user.aws.ssh_username
  #  override.ssh.private_key_path  = config.user.aws.ssh_pubkey
  #end

  # The sole function of this is to get all the puppet 'stuff' into a known
  # location on the remote instance
  config.vm.provision :shell do |shell|
    shell.inline = "ln -s /vagrant /vagrant/modules/#{module_name}"
  end

  # Now that the shell.inline provisioning has put stuff in known locations,
  # run a puppet apply and test that the module works.
  config.vm.provision :puppet do |puppet|
    puppet.hiera_config_path = "data/hiera.yaml"
    puppet.module_path       = "modules"
    puppet.options           = "--verbose --debug --summarize"
    puppet.manifests_path    = "manifests"
    puppet.working_directory = "/vagrant"
    puppet.facter            = {}
  end
end
