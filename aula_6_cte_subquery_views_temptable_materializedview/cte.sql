-- Top 5 clientes por valor total gasto

with valor_gasto as (
    select
        c.customer_id,
        c.company_name,
        sum((od.unit_price * od.quantity) * (1 - od.discount)) as total_pedidos_cliente
    from customers c
    inner join orders o on c.customer_id = o.customer_id
    inner join order_details od on o.order_id = od.order_id
    group by c.customer_id, c.company_name
)

select *
from valor_gasto
order by total_pedidos_cliente desc
limit 5

-- Funcionários acima da média de vendas da equipe

with vendas as (
    select
        e.first_name || ' ' || e.last_name as funcionario,
        sum((od.unit_price * od.quantity) * (1 - od.discount)) as total_vendas
    from employees e
    inner join orders o on e.employee_id = o.employee_id
    inner join order_details od on o.order_id = od.order_id
    group by e.employee_id, e.first_name, e.last_name
),

media_equipe as (
    select
        avg(total_vendas) as media_vendas_equipe
    from vendas
)

select
    funcionario,
    total_vendas
from vendas
where total_vendas > (
    select
        media_vendas_equipe
    from media_equipe
)
order by total_vendas desc

-- Retenção de clientes: quem fez mais de um pedido?

with total_pedidos as (
    select
        o.customer_id,
        c.company_name,
        count(o.order_id) as total_pedidos
    from customers c
    inner join orders o on c.customer_id = o.customer_id
    group by o.customer_id, c.company_name
)

select *
from total_pedidos
where total_pedidos > 1
order by total_pedidos desc

-- Produtos mais vendidos que a média da sua categoria

with total_vendido_produto as (
    select
        p.product_id,
        p.product_name,
        ct.category_name,
        sum((od.unit_price * od.quantity) * (1 - od.discount)) as total_vendas_produto
    from products p
    inner join order_details od on p.product_id = od.product_id
    inner join categories ct on p.category_id = ct.category_id
    group by p.product_id, p.product_name, ct.category_name
),

media_da_categoria as (
    select
        category_name,
        avg(total_vendas_produto) as media_categoria
    from total_vendido_produto
    group by category_name
)

select
    t.product_id,
    t.product_name,
    t.category_name,
    t.total_vendas_produto,
    m.media_categoria
from total_vendido_produto t
inner join media_da_categoria m on t.category_name = m.category_name
where t.total_vendas_produto > m.media_categoria
order by t.total_vendas_produto desc

-- Evolução mensal de vendas com variação percentual

with vendas_mes as (
    select
        extract(month from o.order_date) as mes,
        extract(year from o.order_date) as ano,
        sum((od.unit_price * od.quantity) * (1 - od.discount)) as total_vendas
    from orders o
    inner join order_details od on o.order_id = od.order_id
    group by extract(month from o.order_date), extract(year from o.order_date)
),

mes_anterior as (
    select
        mes,
        ano,
        total_vendas,
        lag(total_vendas) over (order by ano, mes) as total_mes_anterior
    from vendas_mes
)

select
    ano,
    mes,
    total_vendas,
    total_mes_anterior,
    case
        when total_mes_anterior is null then null
        else ROUND(
    ((total_vendas - total_mes_anterior)
     / total_mes_anterior * 100)::numeric, 1
) end AS variacao_percentual
from mes_anterior
order by ano, mes
