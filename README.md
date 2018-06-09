# Postgres HA Sandbox

## Intro

 * https://www.postgresql.org/docs/10/static/high-availability.html
 * The above doc is hard to read since the concepts are spread over many chapters
 * Simple step-by-step guide for PG10: https://blog.raveland.org/post/postgresql_sr/
 * The best thing Postgres builtin tech can do is streaming replication to a hot standby
 * Record-based log shipping is a synonym for streaming replication


## pgcluster01 log

vagrant@pgcluster01:~$ sudo -i -u postgres
postgres@pgcluster01:~$ psql
psql (10.4 (Ubuntu 10.4-2.pgdg18.04+1))
Type "help" for help.

postgres=# CREATE ROLE replicate WITH REPLICATION LOGIN ;
CREATE ROLE
postgres=# set password_encryption = 'scram-sha-256';
SET
alter user replicate password 'foobar';
postgres=# \password replicate
Enter new password: foobar 
Enter it again: foobar 


/etc/postgresql/10/main/postgresql.conf
listen_addresses = '*' 
wal_level = replica
max_wal_senders = 3 # max number of walsender processes
wal_keep_segments = 64 # in logfile segments, 16MB each; 0 disables
#archive_mode/command not configured


"/etc/postgresql/10/main/pg_hba.conf" 100L, 4762C written                    
host    replication    replicate       samenet                scram-sha-256

restart postgres

## pgcluster02 log

stop pg

apply changes as above
host_standby = on

root@pgcluster02:/var/lib/postgresql/10/main# rm -rf *
root@pgcluster02:/var/lib/postgresql/10/main# pg_basebackup -h 10.5.0.10 -D /var/lib/postgresql/10/main/ -P -U replicate --wal-method=stream
Password: 
48758/48758 kB (100%), 1/1 tablespace

 /usr/lib/postgresql/10/bin/postgres -D /var/lib/postgresql/10/main -c config_file=/etc/postgresql/10/main/postgresql.conf


## try it

pgcluster01
postgres@pgcluster01:~$ psql dellstore2 -c "update products set title = 'XXXX' where prod_id = 1"

postgres@pgcluster02:~$ psql dellstore2 -c 'select * from products where prod_id = 1'
 prod_id | category | title |      actor       | price | special | common_prod_id 
---------+----------+-------+------------------+-------+---------+----------------
       1 |       14 | XXXX  | PENELOPE GUINESS | 25.99 |       0 |           1976
(1 row)

