-- Produtos acima da média de preço do catálogo

select
    product_name,
    unit_price
from products
where unit_price > (
    select
        avg(unit_price)
    from products
)

-- Clientes que nunca fizeram um pedido

select
    c.customer_id,
    c.company_name
from customers c
where c.customer_id not in (
    select
        o.customer_id
    from orders o
);

-- caso customer_id seja null
select
    c.customer_id,
    c.company_name
from customers c
where not exists (
    select 1
    from orders o
    where o.customer_id = c.customer_id
)

-- Funcionário com o maior número de pedidos

select
    e.first_name || ' ' || e.last_name as funcionario,
    count(o.order_id) as total_pedidos
from employees e
inner join orders o on e.employee_id = o.employee_id
group by e.employee_id, e.first_name || ' ' || e.last_name
having count(order_id) = (
    select max(total)
    from (
        select count(order_id) as total
        from orders
        group by employee_id))
order by total_pedidos desc

-- Produtos que nunca foram vendidos

select
    p.product_id,
    p.product_name
from products p
where not exists (
    select 1
    from order_details od
    where p.product_id = od.product_id
)

-- Pedidos com valor acima da média do mesmo cliente

SELECT
    o.customer_id,
    o.order_id,
    o.order_date,
    ROUND(SUM(od.unit_price * od.quantity)::numeric, 2) AS valor_pedido,
    ROUND((
        SELECT AVG(sub_total)
        FROM (
            SELECT SUM(od2.unit_price * od2.quantity) AS sub_total
            FROM   orders        o2
            JOIN   order_details od2 ON o2.order_id = od2.order_id
            WHERE  o2.customer_id = o.customer_id
            GROUP BY o2.order_id
        ) medias
    )::numeric, 2) AS media_cliente
FROM orders        o
JOIN order_details od ON o.order_id = od.order_id
GROUP BY o.customer_id, o.order_id, o.order_date
HAVING SUM(od.unit_price * od.quantity) > (
    SELECT AVG(sub_total)
    FROM (
        SELECT SUM(od2.unit_price * od2.quantity) AS sub_total
        FROM   orders        o2
        JOIN   order_details od2 ON o2.order_id = od2.order_id
        WHERE  o2.customer_id = o.customer_id
        GROUP BY o2.order_id
    ) medias
)
ORDER BY o.customer_id, valor_pedido DESC;