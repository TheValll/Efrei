# Rapport TP1 - Hive

```bash
cd docker-hadoop-spark
docker-compose up -d
```

### Copier les fichiers CSV dans le namenode

```bash
docker cp customers.csv namenode:/customers.csv
docker cp products.csv namenode:/products.csv
docker cp orders.csv namenode:/orders.csv
docker cp orders_items.csv namenode:/orders_items.csv
```

### Charger les fichiers dans HDFS

```bash
docker exec -it namenode bash
```

```bash
hdfs dfs -mkdir -p /data/hive_tp/raw/customers
hdfs dfs -mkdir -p /data/hive_tp/raw/products
hdfs dfs -mkdir -p /data/hive_tp/raw/orders
hdfs dfs -mkdir -p /data/hive_tp/raw/orders_items

hdfs dfs -put /customers.csv /data/hive_tp/raw/customers/
hdfs dfs -put /products.csv /data/hive_tp/raw/products/
hdfs dfs -put /orders.csv /data/hive_tp/raw/orders/
hdfs dfs -put /orders_items.csv /data/hive_tp/raw/orders_items/
```

### Se connecter à Hive

```bash
docker exec -it hive-server bash
```

---

## Partie A — Tables externes (raw)

### Commande

```bash
beeline -u jdbc:hive2://localhost:10000 -f /sql/01_partA_external.sql
```

### Requête : `select count(*) as nb_customers from customers_raw;`

| nb_customers |
|--------------|
| 5            |

### Requête : `select * from orders_raw limit 10;`

| order_id | customer_id | order_ts            | status    |
|----------|-------------|---------------------|-----------|
| 100      | 1           | 2025-01-10 10:15:00 | PAID      |
| 101      | 2           | 2025-01-11 14:30:00 | PAID      |
| 102      | 3           | 2025-01-11 16:45:00 | CANCELLED |
| 103      | 4           | 2025-01-12 09:00:00 | PAID      |
| 104      | 5           | 2025-01-12 18:20:00 | PENDING   |
| 105      | 1           | 2025-01-13 11:10:00 | PAID      |

---

## Partie B — Tables curated (Parquet)

### Commande

```bash
beeline -u jdbc:hive2://localhost:10000 -f /sql/02_partB_curated.sql
```

### Requête : `select count(*) from customers_accurated;`

| _c0 |
|-----|
| 5   |

### Requête : `select count(*) from products_accurated;`

| _c0 |
|-----|
| 5   |

### Requête : `select count(*) from orders_accurated;`

| _c0 |
|-----|
| 6   |

### Requête : `select count(*) from orders_items_accurated;`

| _c0 |
|-----|
| 6   |

---

## Partie C — Table partitionnée

### Commande

```bash
beeline -u jdbc:hive2://localhost:10000 -f /sql/03_partC_partitioned.sql
```

### Requête : commandes par jour

```sql
select order_date, count(*) as nb
from orders_accurated_partitioned
group by order_date
order by order_date;
```

| order_date  | nb |
|-------------|----|
| 2025-01-10  | 1  |
| 2025-01-11  | 2  |
| 2025-01-12  | 2  |
| 2025-01-13  | 1  |

---

## Partie D — Analytics

### Commande

```bash
beeline -u jdbc:hive2://localhost:10000 -f /sql/04_partD_analytics.sql
```

### Requête : chiffre d'affaires par jour (statut PAID)

```sql
select o.order_date as jour,
       round(sum(oi.quantity * p.unit_price), 2) as ca
from orders_accurated_partitioned o
join orders_items_accurated oi on o.order_id = oi.order_id
join products_accurated p on oi.product_id = p.product_id
where o.status = 'PAID'
group by o.order_date
order by jour;
```

| jour        | ca      |
|-------------|---------|
| 2025-01-10  | 740.0   |
| 2025-01-11  | 1200.0  |
| 2025-01-12  | 240.0   |
| 2025-01-13  | 195.0   |

### Requête : top 5 clients par CA (statut PAID)

```sql
select c.customer_id,
       c.full_name,
       round(sum(oi.quantity * p.unit_price), 2) as ca_total
from customers_accurated c
join orders_accurated o on c.customer_id = o.customer_id
join orders_items_accurated oi on o.order_id = oi.order_id
join products_accurated p on oi.product_id = p.product_id
where o.status = 'PAID'
group by c.customer_id, c.full_name
order by ca_total desc
limit 5;
```

| customer_id | full_name    | ca_total |
|-------------|--------------|----------|
| 2           | Bob Dupont   | 1200.0   |
| 1           | Alice Martin | 935.0    |
| 4           | Diana Kamga  | 240.0    |
