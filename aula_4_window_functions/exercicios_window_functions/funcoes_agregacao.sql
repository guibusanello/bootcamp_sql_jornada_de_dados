-- Total de vendas acumulado por funcionário (SUM)

select
    e.first_name || ' ' || e.last_name as nome_funcionario,
    o.order_id,
    o.order_date,
    sum((od.unit_price * od.quantity) * (1 - od.discount)) as valor_pedido,
    sum(sum((od.unit_price * od.quantity) * (1 - od.discount))) over (
        PARTITION BY e.employee_id
        ORDER BY     o.order_date, o.order_id
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) as total_acumulado
from employees e
inner join orders o on e.employee_id = o.employee_id
inner join order_details od on o.order_id = od.order_id
group by e.employee_id,
    e.first_name || ' ' || e.last_name,
    o.order_id,
    o.order_date
order by nome_funcionario

-- Média móvel do frete por cliente

select
    customer_id,
    order_id,
    order_date,
    freight,
    avg(freight) over (
        partition by customer_id
        order by order_date, order_id
        rows between unbounded preceding and current row)
from orders

-- Contagem progressiva de pedidos por funcionário

select
    e.employee_id,
    e.first_name || ' ' || e.last_name as nome_funcionario,
    o.order_date,
    count(o.order_id) over (
        partition by e.employee_id
        order by o.order_date, o.order_id
        rows between unbounded preceding and current row) as total_pedidos_acumulado
from employees e 
inner join orders o on e.employee_id = o.employee_id

-- Menor preço praticado por categoria

select
    p.product_name,
    ct.category_name,
    p.unit_price,
    min(p.unit_price) over (
        partition by ct.category_id) as preco_min_categoria
from categories ct
inner join products p on ct.category_id = p.category_id
order by ct.category_name, p.unit_price

-- Maior venda já registrada na carteira do funcionário

select
    e.first_name || ' ' || e.last_name as funcionario,
    o.order_id,
    o.order_date,
    sum((od.unit_price * od.quantity) * (1 - od.discount)) as valor_pedido,
    max(sum((od.unit_price * od.quantity) * (1 - od.discount))) over (
        partition by e.employee_id
        order by o.order_date, o.order_id
        rows between unbounded preceding and current row) as maior_venda_acumulada
from employees e
inner join orders o on e.employee_id = o.employee_id
inner join order_details od on o.order_id = od.order_id
group by e.employee_id, e.first_name || ' ' || e.last_name, o.order_id, o.order_date

-- Comparação do frete de cada pedido com a média da rota

select
    order_id,
    ship_country,
    freight,
    avg(freight) over (
        partition by ship_country) as media,
    min(freight) over (
        partition by ship_country) as minimo,
    max(freight) over (partition by ship_country) as maximo
from orders

-- Participação percentual de cada produto nas vendas da categoria

select
    p.product_id,
    p.product_name,
    ct.category_name,
    sum((od.unit_price * od.quantity) * (1 - od.discount)) as total_vendido,
    sum(sum((od.unit_price * od.quantity) * (1 - od.discount))) over (
        partition by ct.category_id) as total_categoria,
    sum((od.unit_price * od.quantity) * (1 - od.discount))
        / sum(sum((od.unit_price * od.quantity) * (1 - od.discount))) over (
            partition by ct.category_id) * 100 as percentual
from categories ct
inner join products p on ct.category_id = p.category_id
inner join order_details od on p.product_id = od.product_id
group by ct.category_id, p.product_id, p.product_name, ct.category_name
order by ct.category_name, percentual desc

-- Evolução do ticket médio por funcionário ao longo dos pedidos

select
    e.first_name || ' ' || e.last_name as funcionario,
    o.order_id,
    o.order_date,
    sum((od.unit_price * od.quantity) * (1 - od.discount)) as valor_pedido,
    avg(sum((od.unit_price * od.quantity) * (1 - od.discount))) over (
        partition by e.employee_id
        order by o.order_date, o.order_id
        rows between unbounded preceding and current row) as ticket_medio_acumulado,
    count(o.order_id) over (
        partition by e.employee_id
        order by o.order_date, o.order_id
        rows between unbounded preceding and current row) as contagem_pedidos_acumulada
from employees e
inner join orders o on e.employee_id = o.employee_id
inner join order_details od on o.order_id = od.order_id
group by e.employee_id, e.first_name || ' ' || e.last_name, o.order_id, o.order_date
order by funcionario, o.order_date, o.order_id

-- Painel de desempenho de produtos por categoria

select
    p.product_name,
    ct.category_name,
    sum((od.unit_price * od.quantity) * (1 - od.discount)) as total_vendido,
    sum(sum((od.unit_price * od.quantity) * (1 - od.discount))) over (
        partition by ct.category_id) as total_categoria,
    avg(sum((od.unit_price * od.quantity) * (1 - od.discount))) over (
        partition by ct.category_id) as media_categoria,
    min(sum((od.unit_price * od.quantity) * (1 - od.discount))) over (
        partition by ct.category_id) as min_categoria,
    max(sum((od.unit_price * od.quantity) * (1 - od.discount))) over (
        partition by ct.category_id) as max_categoria
from categories ct
inner join products p on ct.category_id = p.category_id
inner join order_details od on p.product_id = od.product_id
group by ct.category_id, p.product_id, p.product_name, ct.category_name
order by ct.category_name, total_vendido desc

-- Análise completa de pedidos por funcionário

select
    o.order_id,
    e.first_name || ' ' || e.last_name as funcionario,
    o.order_date,
    sum((od.unit_price * od.quantity) * (1 - od.discount)) as valor_pedido,
    sum(sum((od.unit_price * od.quantity) * (1 - od.discount))) over (
        partition by e.employee_id order by o.order_date, o.order_id) as total_acumulado,
    avg(sum((od.unit_price * od.quantity) * (1 - od.discount))) over (
        partition by e.employee_id order by o.order_date, o.order_id) as media_acumulada,
    min(sum((od.unit_price * od.quantity) * (1 - od.discount))) over (
        partition by e.employee_id order by o.order_date, o.order_id) as min_valor_pedido,
    max(sum((od.unit_price * od.quantity) * (1 - od.discount))) over (
        partition by e.employee_id order by o.order_date, o.order_id) as max_valor_pedido,
    count(o.order_id) over (partition by e.employee_id order by o.order_date, o.order_id) as pedidos_acumulados
from employees e
inner join orders o on e.employee_id = o.employee_id
inner join order_details od on o.order_id = od.order_id
group by o.order_id, e.first_name || ' ' || e.last_name, o.order_date, e.employee_id
order by funcionario, pedidos_acumulados

