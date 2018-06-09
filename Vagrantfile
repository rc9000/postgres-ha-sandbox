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

        # setup replication master
        sudo -i -u postgres psql -c 'CREATE ROLE replicate WITH REPLICATION LOGIN'
        sudo -i -u postgres psql -c "set password_encryption = 'scram-sha-256' ; alter user replicate password 'foobar'"
        cp /mnt/host/postgresql.conf /etc/postgresql/10/main/postgresql.conf   
        echo "host    replication    replicate       samenet                scram-sha-256" >> /etc/postgresql/10/main/pg_hba.conf
        /etc/init.d/postgresql restart


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

        # setup replication slave
        sudo -i -u postgres echo 10.5.0.10:5432:replication:replicate:foobar > ~postgres/.pgpass 
        chown postgres:postgres ~postgres/.pgpass  
        chmod 600 ~postgres/.pgpass  
        /etc/init.d/postgresql stop
        cd /var/lib/postgresql/10/main
        rm -rf *
        sudo -i -u postgres  pg_basebackup -h 10.5.0.10 -D /var/lib/postgresql/10/main/ -P -U replicate --wal-method=stream
        sudo -i -u postgres cp /mnt/host/recovery.conf /var/lib/postgresql/10/main/ 
        /etc/init.d/postgresql start
        sleep 5
        tail -20 /var/log/postgresql/postgresql-10-main.log 

    SHELL
    e.vm.hostname = "pgcluster02"
    e.vm.network "forwarded_port", guest: 5432, host: 25432, host_ip: "127.0.0.1"
    e.vm.network "private_network", ip: "10.5.0.11"
  end




end

