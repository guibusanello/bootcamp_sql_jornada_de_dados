-- Data do próximo pedido de cada cliente

select
    customer_id,
    order_id,
    order_date,
    lead(order_date) over (
        partition by customer_id
        order by order_date, order_id) as proximo_pedido
from orders
order by customer_id, order_date, order_id

-- Data do pedido anterior de cada cliente

select
    customer_id,
    order_id,
    order_date as data_pedido_atual,
    coalesce(lag(order_date) over (
        partition by customer_id
        order by order_date, order_id)::text, 'primeiro pedido') as pedido_anterior
from orders
order by customer_id, order_date, order_id

-- Primeiro pedido já feito por cada funcionário

select
    e.first_name || ' ' || e.last_name as funcionario,
    o.order_date as data_pedido_atual,
    first_value(o.order_date) over (partition by e.first_name || ' ' || e.last_name order by o.order_date) as data_primeiro_pedido
from employees e
inner join orders o on e.employee_id = o.employee_id
group by e.first_name || ' ' || e.last_name, o.order_date
order by funcionario

-- Produto mais caro de cada categoria

select
    p.product_name,
    ct.category_name,
    p.unit_price,
    last_value(p.unit_price) over (partition by ct.category_id order by p.unit_price
    ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) as top_preco_categoria
from categories ct
inner join products p on ct.category_id = p.category_id
group by p.product_name,
    ct.category_name,
    p.unit_price,
    ct.category_id
order by ct.category_name

-- Diferença de frete entre pedidos consecutivos do mesmo cliente

select
    customer_id,
    order_date,
    order_id,
    freight,
    coalesce(lag(freight) over (partition by customer_id order by order_date, order_id)::text, 'primeiro pedido') as frete_pedido_anterior,
    freight - lag(freight) over (partition by customer_id order by order_date, order_id) as dif_frete
from orders
order by customer_id

-- Variação do valor entre pedidos consecutivos por funcionário

select
    e.first_name || ' ' || e.last_name as funcionario,
    o.order_id,
    o.order_date,
    sum((od.unit_price * od.quantity) * (1 - od.discount)) as valor_pedido,
    lag(sum((od.unit_price * od.quantity) * (1 - od.discount))) over (
        partition by e.employee_id
        order by o.order_date, o.order_id) as valor_pedido_anterior,
    lead(sum((od.unit_price * od.quantity) * (1 - od.discount))) over (
        partition by e.employee_id
        order by o.order_date, o.order_id) as valor_pedido_posterior
from employees e
inner join orders o on e.employee_id = o.employee_id
inner join order_details od on o.order_id = od.order_id
group by e.employee_id, e.first_name || ' ' || e.last_name, o.order_id, o.order_date
order by funcionario, o.order_date

-- Comparação de cada pedido com o primeiro e o último do cliente

select
    o.customer_id,
    o.order_id,
    o.order_date,
    sum((od.unit_price * od.quantity) * (1 - od.discount)) as valor_pedido,
    first_value(sum((od.unit_price * od.quantity) * (1 - od.discount))) over (
        partition by o.customer_id
        order by o.order_date, o.order_id
        rows between unbounded preceding and unbounded following) as valor_primeiro_pedido,
    last_value(sum((od.unit_price * od.quantity) * (1 - od.discount))) over (
        partition by o.customer_id
        order by o.order_date, o.order_id
        rows between unbounded preceding and unbounded following) as valor_ultimo_pedido
from orders o
inner join order_details od on o.order_id = od.order_id
group by o.customer_id, o.order_id, o.order_date
order by o.customer_id, o.order_date

-- Intervalo em dias entre pedidos consecutivos por cliente

select
    customer_id,
    order_date as data_pedido_atual,
    lag(order_date) over (partition by customer_id order by order_date, order_id) as data_pedido_anterior,
    order_date - lag(order_date) over (partition by customer_id order by order_date, order_id) as dif_data_pedido
from orders
group by customer_id, order_date, order_id
order by customer_id, order_date, order_id

-- Evolução do preço dos produtos ao longo das orders de compra

select
    p.product_id as id_produto,
    p.product_name as produto,
    o.order_id as id_pedido,
    o.order_date as data_pedido,
    p.unit_price as preco_produto,
    od.unit_price as preco_pedido,
    lag(od.unit_price) over (partition by p.product_id order by o.order_date, o.order_id) as preco_pedido_anterior,
    lead(od.unit_price) over (partition by p.product_id order by o.order_date, o.order_id) as preco_pedido_posterior,
    first_value(od.unit_price) over (partition by p.product_id order by o.order_date, o.order_id) as preco_primeiro_pedido
from products p
inner join order_details od on p.product_id = od.product_id
inner join orders o on od.order_id = o.order_id
order by p.product_id, o.order_date, o.order_id

-- Análise completa de evolução de pedidos por cliente

select
    o.customer_id,
    o.order_id,
    sum((od.unit_price * od.quantity) * (1 - od.discount)) as valor_pedido, 
    lag(sum((od.unit_price * od.quantity) * (1 - od.discount))) over (partition by o.customer_id order by o.order_date, o.order_id) as valor_pedido_anterior,
    lead(sum((od.unit_price * od.quantity) * (1 - od.discount))) over (partition by o.customer_id order by o.order_date, o.order_id) as valor_pedido_posterior,
    first_value(sum((od.unit_price * od.quantity) * (1 - od.discount))) over (partition by o.customer_id order by o.order_date, o.order_id) as valor_primeiro_pedido,
    last_value(sum((od.unit_price * od.quantity) * (1 - od.discount))) over (partition by o.customer_id order by o.order_date, o.order_id ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) as valor_ultimo_pedido
from orders o
inner join order_details od on o.order_id = od.order_id
group by o.customer_id, o.order_date, o.order_id
order by o.customer_id, o.order_date, o.order_id


