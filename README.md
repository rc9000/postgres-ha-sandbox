# Postgres HA Sandbox

## Intro

 * https://www.postgresql.org/docs/10/static/high-availability.html
 * The above doc is hard to read since the concepts are spread over many chapters
 * Simple step-by-step guide for PG10: https://blog.raveland.org/post/postgresql_sr/
 * The best thing Postgres builtin tech can do is streaming replication to a hot standby
 * Record-based log shipping is a synonym for streaming replication

## Troubleshooting

### Identifier Mismatch

The master and slave need to match up, ie. slave needs to originate from pg_basebackup.
If it isn't the system identifiers don't match up and the slave refuses to start:

    2018-06-09 21:17:55.172 UTC [2104] FATAL:  database system identifier differs between the primary and standby
    2018-06-09 21:17:55.172 UTC [2104] DETAIL:  The primary's identifier is 6565195479380034189, the standby's identifier is 6564997952538579566.

These identifiers are randomly chosen at DB creation time
    
### basebackup

The -D option designates the local directory, the whole remote cluster will be restored to this location.

## Verification

    postgres@pgcluster01:~$ psql dellstore2 -c "update products set title = 'XXXX' where prod_id = 1"
    
    postgres@pgcluster02:~$ psql dellstore2 -c 'select * from products where prod_id = 1'
     prod_id | category | title |      actor       | price | special | common_prod_id 
    ---------+----------+-------+------------------+-------+---------+----------------
           1 |       14 | XXXX  | PENELOPE GUINESS | 25.99 |       0 |           1976
    (1 row)

