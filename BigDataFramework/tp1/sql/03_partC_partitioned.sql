use hive_tp;

-- active le partitionnement dynamique
set hive.exec.dynamic.partition=true;
-- autorise toutes les partitions a etre dynamiques
set hive.exec.dynamic.partition.mode=nonstrict;

drop table if exists orders_accurated_partitioned;
create table orders_accurated_partitioned (
  order_id    int,
  customer_id int,
  order_ts    timestamp,
  status      string
)
-- definit une partition par date
partitioned by (order_date date)
stored as parquet;

-- remplit la table partitionnee
insert overwrite table orders_accurated_partitioned
-- ecrit dans la partition order_date
partition (order_date)
select order_id, customer_id, order_ts, status, order_date
from orders_accurated;

-- compte les commandes par jour
select order_date, count(*) as nb
from orders_accurated_partitioned
group by order_date
order by order_date;
