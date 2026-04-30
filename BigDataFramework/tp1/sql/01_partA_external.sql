-- cree la base hive_tp si elle n'existe pas
create database if not exists hive_tp
-- place la base dans le dossier hdfs /data/hive_tp
location '/data/hive_tp';

-- selectionne la base hive_tp pour les requetes suivantes
use hive_tp;

-- supprime la table customers_raw si elle existe deja
drop table if exists customers_raw;
-- cree une table externe customers_raw
create external table customers_raw (
  customer_id int,
  full_name   string,
  city        string,
  country     string
)
-- separe les colonnes par une virgule
row format delimited fields terminated by ','
-- stocke la table en fichier texte
stored as textfile
-- pointe la table sur le dossier hdfs des customers
location '/data/hive_tp/raw/customers'
-- ignore la premiere ligne du csv (entete)
tblproperties ("skip.header.line.count"="1");

-- supprime la table products_raw si elle existe
drop table if exists products_raw;
create external table products_raw (
  product_id int,
  category   string,
  brand      string,
  unit_price double
)
row format delimited fields terminated by ','
stored as textfile
location '/data/hive_tp/raw/products'
tblproperties ("skip.header.line.count"="1");

drop table if exists orders_raw;
create external table orders_raw (
  order_id    int,
  customer_id int,
  order_ts    string,
  status      string
)
row format delimited fields terminated by ','
stored as textfile
location '/data/hive_tp/raw/orders'
tblproperties ("skip.header.line.count"="1");

drop table if exists orders_items_raw;
create external table orders_items_raw (
  order_id   int,
  product_id int,
  quantity   int
)
row format delimited fields terminated by ','
stored as textfile
location '/data/hive_tp/raw/orders_items'
tblproperties ("skip.header.line.count"="1");

-- compte le nombre de clients dans la table
select count(*) as nb_customers from customers_raw;
-- affiche les 10 premieres commandes
select * from orders_raw limit 10;
