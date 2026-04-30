use hive_tp;

drop table if exists customers_accurated;
create table customers_accurated (
  customer_id int,
  full_name   string,
  city        string,
  country     string
)
-- stocke la table au format parquet
stored as parquet;

-- ecrase et remplit la table customers_accurated
insert overwrite table customers_accurated
select customer_id, trim(full_name), trim(city), trim(country)
from customers_raw
where customer_id is not null;

drop table if exists products_accurated;
create table products_accurated (
  product_id int,
  category   string,
  brand      string,
  unit_price double
)
stored as parquet;

insert overwrite table products_accurated
select product_id, trim(category), trim(brand), unit_price
from products_raw
where product_id is not null and unit_price is not null;

drop table if exists orders_accurated;
create table orders_accurated (
  order_id    int,
  customer_id int,
  order_ts    timestamp,
  order_date  date,
  status      string
)
stored as parquet;

insert overwrite table orders_accurated
select order_id,
       customer_id,
       -- convertit la chaine en timestamp
       cast(order_ts as timestamp),
       -- extrait la date du timestamp
       to_date(order_ts),
       -- met le statut en majuscules apres un trim
       upper(trim(status))
from orders_raw
where order_id is not null;

drop table if exists orders_items_accurated;
create table orders_items_accurated (
  order_id   int,
  product_id int,
  quantity   int
)
stored as parquet;

insert overwrite table orders_items_accurated
select order_id, product_id, quantity
from orders_items_raw
where order_id is not null and product_id is not null and quantity > 0;

select count(*) from customers_accurated;
select count(*) from products_accurated;
select count(*) from orders_accurated;
select count(*) from orders_items_accurated;
