-- Materialized view de resumo de vendas por categoria
-- Crie uma materialized view que exiba, para cada categoria, o nome, a quantidade de produtos vendidos e o total arrecadado. Em seguida consulte-a filtrando as categorias com total acima de 100.000. Por fim, execute o comando de atualização da view.

create materialized view mv_vendas_categoria as
select
    p.category_id,
    ct.category_name,
    count(od.quantity) as total_produtos_vendidos,
    sum((od.unit_price * od.quantity) * (1 - od.discount)) as total_valor_vendido
from categories ct
inner join products p on ct.category_id = p.category_id
inner join order_details od on p.product_id = od.product_id
group by p.category_id, ct.category_name
order by p.category_id;

select *
from mv_vendas_categoria
where total_valor_vendido > 100000;

refresh materialized view mv_vendas_categoria;

-- Materialized view com índice para consultas rápidas
-- Crie uma materialized view com o nome do funcionário, total de pedidos, total vendido e ticket médio. Por fim consulte os 3 funcionários com maior ticket médio.

create materialized view mv_desempenho_funcionarios as
select
    e.first_name || ' ' || e.last_name as funcionario,
    count(o.order_id) as qtd_pedidos_funcionario,
    sum((od.unit_price * od.quantity) * (1 - od.discount)) as total_vendas_funcionario,
    sum((od.unit_price * od.quantity) * (1 - od.discount)) / count(o.order_id) as ticket_medio
from employees e
inner join orders o on e.employee_id = o.employee_id
inner join order_details od on o.order_id = od.order_id
group by e.employee_id, e.first_name, e.last_name
order by e.employee_id;

select
    funcionario,
    ticket_medio,
    total_vendas_funcionario
from mv_desempenho_funcionarios
order by ticket_medio desc
limit 3

-- Refresh com e sem bloqueio de leitura
-- Cria mv_resumo_clientes com total de pedidos e total gasto por cliente. Demonstra a diferença entre REFRESH e REFRESH CONCURRENTLY com comentários explicando quando usar cada um.

create materialized view mv_resumo_clientes as
select
    c.customer_id,
    c.company_name,
    count(o.order_id) as qtd_pedidos_cliente,
    sum((od.unit_price * od.quantity) * (1 - od.discount)) as total_pedidos_cliente
from customers c
inner join orders o on c.customer_id = o.customer_id
inner join order_details od on o.order_id = od.order_id
group by c.customer_id, c.company_name;

-- Refresh padrão bloqueia leituras durante a atualização.
refresh materialized view mv_resumo_clientes;

-- Refresh concurrently não bloqueia consulta, sendo melhor em produção onde a view é consultada continuamente.
refresh materialized view concurrently mv_resumo_clientes;

select *
from mv_resumo_clientes
order by total_pedidos_cliente desc

-- Materialized view com CTE e window function
-- Cria mv_evolucao_vendas_mensais com total mensal, total anterior e variação percentual usando CTE e LAG.
-- Consulta filtra meses com queda e demonstra como recriar a view com DROP + CREATE

create materialized view mv_evolucao_vendas_mensais as
with vendas as (
select
    extract(year from o.order_date) as ano,
    extract(month from o.order_date) as mes,
    sum((od.unit_price * od.quantity) * (1 - od.discount)) as total_vendas_mes
from orders o
inner join order_details od on o.order_id = od.order_id
group by extract(year from o.order_date), extract(month from o.order_date)
order by ano, mes
),

total_anterior as (
    select
        ano,
        mes,
        total_vendas_mes,
        lag(total_vendas_mes) over (order by ano, mes) as total_vendas_anterior
    from vendas
)

select
    *,
    (total_vendas_anterior - total_vendas_mes) / total_vendas_anterior * 100 as variacao_percentual
from total_anterior;

-- consulta
select * 
from mv_evolucao_vendas_mensais
where variacao_percentual < 0
order by ano, mes

-- drop + create
drop materialized view if exists mv_evolucao_vendas_mensais
create materialized view ... as

-- Camada analítica com múltiplas materialized views
-- Constrói 3 materialized views encadeadas: mv_vendas_produto → mv_ranking_produto_categoria → mv_top3_categoria. Demonstra a ordem correta de refresh.

create materialized view mv_vendas_produto as
select
    p.product_id,
    p.product_name,
    p.category_id,
    ct.category_name,
    sum((od.unit_price * od.quantity) * (1 - od.discount)) as total_vendas_produto
from products p
inner join categories ct on p.category_id = ct.category_id
inner join order_details od on p.product_id = od.product_id
group by p.product_id, p.product_name, p.category_id, ct.category_name;

-- Uma view consome da outra

create materialized view mv_ranking_produto_categoria as
select
    product_id,
    product_name,
    category_id,
    category_name,
    total_vendas_produto,
    dense_rank() over (partition by category_id, category_name order by total_vendas_produto desc) as ranking_categoria
from mv_vendas_produto;

create materialized view mv_top3_categoria as
select *
from mv_ranking_produto_categoria
where ranking_categoria <=3;

select *
from mv_top3_categoria;

refresh materialized view mv_vendas_produto;
refresh materialized view mv_ranking_produto_categoria;
refresh materialized view mv_top3_categoria;