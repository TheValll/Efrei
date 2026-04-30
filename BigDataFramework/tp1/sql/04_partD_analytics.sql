use hive_tp;

-- selectionne la date de commande comme jour
select o.order_date as jour,
       -- somme quantite multipliee par prix, arrondie a 2 decimales
       round(sum(oi.quantity * p.unit_price), 2) as ca
from orders_accurated_partitioned o
join orders_items_accurated oi on o.order_id = oi.order_id
join products_accurated p on oi.product_id = p.product_id
where o.status = 'PAID'
group by o.order_date
order by jour;

select c.customer_id,
       c.full_name,
       -- ca total du client arrondi
       round(sum(oi.quantity * p.unit_price), 2) as ca_total
from customers_accurated c
join orders_accurated o on c.customer_id = o.customer_id
join orders_items_accurated oi on o.order_id = oi.order_id
join products_accurated p on oi.product_id = p.product_id
where o.status = 'PAID'
group by c.customer_id, c.full_name
order by ca_total desc
limit 5;

