#!/bin/bash


echo "deb http://apt.postgresql.org/pub/repos/apt/ bionic-pgdg main" > /etc/apt/sources.list.d/pgdg.list
wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
apt-get -y update
apt-get -y install postgresql-10 postgresql-client-10 aptitude 

sudo -i -u postgres wget http://pgfoundry.org/frs/download.php/543/dellstore2-normal-1.0.tar.gz
sudo -i -u postgres tar xvfz dellstore2-normal-1.0.tar.gz
sudo -i -u postgres createdb dellstore2
sudo -i -u postgres psql dellstore2 -f dellstore2-normal-1.0/dellstore2-normal-1.0.sql

 
