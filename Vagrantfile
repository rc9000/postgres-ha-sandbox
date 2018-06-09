Vagrant.configure("2") do |config|

  config.vm.provider "virtualbox" do |vb|
    vb.memory = "2560"
    vb.cpus = "2"
  end

  config.vm.define "pgcluster01" do |e|
    e.vm.box = "pgcluster01"
    e.vm.box = "ubuntu/bionic64"
    e.vm.synced_folder ".", "/mnt/host"
    e.vm.provision "shell", inline: <<-SHELL
        . /mnt/host/node_setup.sh

        # setup sample db on master
        sudo -i -u postgres wget http://pgfoundry.org/frs/download.php/543/dellstore2-normal-1.0.tar.gz
        sudo -i -u postgres tar xvfz dellstore2-normal-1.0.tar.gz
        sudo -i -u postgres createdb dellstore2
        sudo -i -u postgres psql dellstore2 -f dellstore2-normal-1.0/dellstore2-normal-1.0.sql
        sudo -i -u postgres psql -c 'CREATE ROLE replicate WITH REPLICATION LOGIN'


    SHELL
    e.vm.hostname = "pgcluster01"
    e.vm.network "forwarded_port", guest: 5432, host: 15432, host_ip: "127.0.0.1"
    e.vm.network "private_network", ip: "10.5.0.10"
  end

  config.vm.define "pgcluster02" do |e|
    e.vm.box = "pgcluster02"
    e.vm.box = "ubuntu/bionic64"
    e.vm.synced_folder ".", "/mnt/host"
    e.vm.provision "shell", inline: <<-SHELL
        . /mnt/host/node_setup.sh
    SHELL
    e.vm.hostname = "pgcluster02"
    e.vm.network "forwarded_port", guest: 5432, host: 25432, host_ip: "127.0.0.1"
    e.vm.network "private_network", ip: "10.5.0.11"
  end




end

