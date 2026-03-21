-- Top 10 produtos mais vendidos
select p.product_id,
    p.product_name,
    SUM(
        (od.unit_price * od.quantity) * (1 - od.discount)
    ) as total_vendas_produto
from products p
    inner join order_details od on p.product_id = od.product_id
group by p.product_id,
    p.product_name
order by total_vendas_produto desc
limit 10 

-- Top 10 produtos mais vendidos que não estão descontinuados
select p.product_id,
    p.product_name,
    SUM(
        (od.unit_price * od.quantity) * (1 - od.discount)
    ) as total_vendas_produto
from products p
    inner join order_details od on p.product_id = od.product_id
where discontinued = 0
group by p.product_id,
    p.product_name
order by total_vendas_produto desc
limit 10