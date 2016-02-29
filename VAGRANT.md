Here's how you can quickly get testing or developing against the cookbook thanks to [Vagrant](http://vagrantup.com/).

    Ensure you have puppet installed on your mac:
    
    # see http://caskroom.io
    brew cask install puppet
    
    Ensure you have bundler installed on your mac:
    
    sudo gem install bundler
    
    Install vagrant plugins
    
    vagrant plugin install vagrant-r10k
    

    Bootstrap the puppet module you're testing.
    
    # NOTE: due to how Puppet operates, you must name directory the same as the module name when you clone
    git clone git://plgithub01.hmsonline.com/it/puppet-MODULE.git MODULE
    cd MODULE
    vagrant up BOX # BOX being centos6, ubuntu1404
    
You can then SSH into the running VM using the `vagrant ssh BOX` command.

The VM can easily be stopped and deleted with the `vagrant destroy` command. Please see the official [Vagrant documentation](http://docs.vagrantup.com/v2/cli/index.html) for a more in depth explanation of available commands.
