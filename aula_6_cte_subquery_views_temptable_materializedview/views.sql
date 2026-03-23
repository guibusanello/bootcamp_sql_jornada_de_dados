-- View de resumo dos clientes
-- Para cada cliente, exibir o id, nome da empresa, quantidade total de pedidos realizados e o valor total gasto.

create or replace view vw_resumo_clientes as
select
    c.customer_id,
    c.company_name,
    count(o.order_id) as qtd_pedidos,
    sum((od.unit_price * od.quantity) * (1 - od.discount)) as total_pedidos
from customers c
inner join orders o on c.customer_id = o.customer_id
inner join order_details od on o.order_id = od.order_id
group by c.customer_id, c.company_name
order by c.company_name 

select * from vw_resumo_clientes

-- View de produtos com estoque baixo
-- Listar produtos com units_in_stock menor ou igual a 10, mostrando o nome do produto, categoria, estoque atual e o preço unitário. Ordenar pelo estoque do menor para o maior.

create or replace view vw_estoque_baixo as
select
    p.product_name,
    ct.category_name,
    p.units_in_stock,
    p.unit_price
from categories ct
inner join products p on ct.category_id = p.category_id
where p.units_in_stock <= 10
order by p.units_in_stock 

select * from vw_estoque_baixo

-- View de desempenho de funcionários
-- Exibir para cada funcionário o nome completo, total de pedidos realizados, valor total vendido e o ticket médio por pedido. Use a view para consultar apenas os funcionários com ticket médio acima de 1500.

create or replace view vw_desempenho_funcionarios as
select
    e.first_name || ' ' || e.last_name as funcionario,
    count(o.order_id) as qtd_pedidos_funcionario,
    sum((od.unit_price * od.quantity) * (1 - od.discount)) as total_pedidos_funcionario,
    sum((od.unit_price * od.quantity) * (1 - od.discount)) / count(o.order_id) as ticket_medio
from employees e
inner join orders o on e.employee_id = o.employee_id
inner join order_details od on o.order_id = od.order_id
group by e.employee_id, e.first_name, e.last_name
order by funcionario

select * from vw_desempenho_funcionarios
where ticket_medio > 1500

-- View de pedidos com atraso
-- Listar os pedidos cuja data de entrega efetiva (shipped_date) foi posterior a data prometida (required_date) com id do pedido, nome do cliente, data prometida, data de entrega e quantidade de dias de atraso.

create or replace view vw_pedidos_atrasados as 
select
    o.order_id,
    c.customer_id,
    c.company_name,
    o.order_date,
    o.shipped_date,
    o.required_date,
    o.shipped_date - o.required_date as dias_atraso
from customers c
inner join orders o on c.customer_id = o.customer_id
where o.shipped_date > o.required_date
order by dias_atraso desc

select * from vw_pedidos_atrasados

-- View evolutiva de vendas mensais
-- Agregar o total vendido por mês e ano, incluindo o total do mês anterior e a variação percentual entre os dois. Depois, filtrar apenas os meses com crescimento positivo.

create or replace view vw_vendas_mensais as
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
        else round(((total_vendas - total_mes_anterior) / total_mes_anterior * 100)::numeric, 2)
        end as variacao_percentual
from mes_anterior
order by ano, mes;

select * from vw_vendas_mensais
where variacao_percentual > 0
