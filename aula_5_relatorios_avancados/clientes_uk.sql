-- Clientes do UK que pagaram mais de 1000 dólares.

select
    c.customer_id,
    c.company_name,
    c.contact_name,
    c.contact_title,
    c.phone,
    SUM((od.unit_price * od.quantity) * (1 - od.discount)) as receita_total
from customers c
INNER JOIN orders o on c.customer_id = o.customer_id
inner join order_details od on o.order_id = od.order_id
where country = 'UK'
group by c.customer_id, c.company_name, c.contact_name, c.contact_title, c.phone
having SUM((od.unit_price * od.quantity) * (1 - od.discount)) > 1000
order by receita_total desc