# Postgres HA Sandbox

## Intro
    

 * This repository provides a pre-made postgresql 10 streaming replication, hot-standby cluster for your high-availability experiments
 * It is based on the very well-written guide in https://blog.raveland.org/post/postgresql_sr/
 * For a complete overview of postgres HA options, visit https://www.postgresql.org/docs/10/static/high-availability.html

## Sample Database

 * The cluster will be loaded with the pgfoundry dellstore2 sample database, available from http://pgfoundry.org/frs/?group_id=1000150&release_id=376

## Troubleshooting

### Identifier Mismatch

The master and slave need to match up, ie. slave needs to originate from pg_basebackup.
If it isn't the system identifiers don't match up and the slave refuses to start:

    2018-06-09 21:17:55.172 UTC [2104] FATAL:  database system identifier differs between the primary and standby
    2018-06-09 21:17:55.172 UTC [2104] DETAIL:  The primary's identifier is 6565195479380034189, the standby's identifier is 6564997952538579566.

These identifiers are randomly chosen at DB creation time
    
### basebackup notes

The -D option designates the local directory, the whole remote cluster will be restored to this location.

## Verification

    postgres@pgcluster01:~$ psql dellstore2 -c "update products set title = 'XXXX' where prod_id = 1"
    
    postgres@pgcluster02:~$ psql dellstore2 -c 'select * from products where prod_id = 1'
     prod_id | category | title |      actor       | price | special | common_prod_id 
    ---------+----------+-------+------------------+-------+---------+----------------
           1 |       14 | XXXX  | PENELOPE GUINESS | 25.99 |       0 |           1976
    (1 row)

## Todo

 * document failover
 * document failback
