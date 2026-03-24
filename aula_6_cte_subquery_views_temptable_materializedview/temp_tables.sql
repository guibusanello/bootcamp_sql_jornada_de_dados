-- Tabela temporária de totais por cliente
-- Tabela com id do cliente, nome do cliente e total gasto. Depois, consultar os 10 maiores.

create temp table tmp_totais_clientes (
    customer_id VARCHAR(5),
    company_name VARCHAR(100),
    total_gasto_cliente NUMERIC(10, 2)
);

insert into tmp_totais_clientes
select
    c.customer_id,
    c.company_name,
    sum((od.unit_price * od.quantity) * (1 - od.discount)) as total_gasto_cliente
from customers c
inner join orders o on c.customer_id = o.customer_id
inner join order_details od on o.order_id = od.order_id
group by c.customer_id, c.company_name
order by total_gasto_cliente desc;

select *
from tmp_totais_clientes
limit 10

-- Tabela temporária com CREATE AS SELECT
-- Criar e popular em uma única instrução uma tabela com o nome do funcionário, total de pedidos e total vendido. Depois, consultar os funcionários com mais de 100 pedidos.

-- tabela
create temp table tmp_vendas_funcionario as
select
    e.first_name || ' ' || e.last_name as funcionario,
    count(distinct o.order_id) as quantidade_pedidos,
    sum((od.unit_price * od.quantity) * (1 - od.discount)) as total_pedidos
from employees e 
inner join orders o on e.employee_id = o.employee_id
inner join order_details od on o.order_id = od.order_id
group by e.employee_id, e.first_name, e.last_name
order by funcionario;
-- consulta
select *
from tmp_vendas_funcionario
where quantidade_pedidos > 100

-- Duas tabelas temporárias com join entre elas
-- Crie uma tabela temporária com o total vendido por produto e uma segunda com a média de vendas por categoria. Em seguida faça um join para listar os produtos que vendem acima da média da categoria.

create temp table tmp_total_produto as
select
    p.product_id,
    p.product_name,
    p.category_id,
    sum((od.unit_price * od.quantity) * (1 - od.discount)) as total_vendas_produto
from products p
inner join order_details od on p.product_id = od.product_id
group by p.product_id, p.product_name, p.category_id;

create temp table tmp_media_categoria as
select
    category_id,
    avg(total_vendas_produto) as media_vendas_categoria
from tmp_total_produto
group by category_id;

select
    tp.product_id,
    tp.product_name,
    tp.category_id,
    tp.total_vendas_produto,
    tm.media_vendas_categoria
from tmp_total_produto tp
inner join tmp_media_categoria tm on tp.category_id = tm.category_id
where tp.total_vendas_produto > tm.media_vendas_categoria
order by tp.category_id

-- Tabela temporária com window function e consulta posterior
-- Crie uma tabela temporária que armazene para cada pedido o id do cliente, data, valor do pedido, valor do pedido anterior e a diferença entre os dois. Depois consulte apenas os pedidos onde o valor cresceu mais de 20% em relação ao anterior.

create temp table tmp_pedidos_clientes as
with valores_pedidos as (
select
    o.customer_id,
    o.order_date,
    sum((od.unit_price * od.quantity) * (1 - od.discount)) as valor_pedido,
    lag(sum((od.unit_price * od.quantity) * (1 - od.discount))) over(partition by o.customer_id order by o.order_date, o.order_id) as valor_pedido_anterior
from orders o
inner join order_details od on o.order_id = od.order_id
group by o.customer_id, o.order_date, o.order_id),

diferenca_pedidos as (
    select
        customer_id,
        order_date,
        valor_pedido,
        valor_pedido_anterior,
        (valor_pedido - valor_pedido_anterior) / valor_pedido_anterior * 100 as diferenca_entre_pedidos
    from valores_pedidos
)

select *
from diferenca_pedidos;


select *
from tmp_pedidos_clientes
where valor_pedido_anterior is not null and diferenca_entre_pedidos > 20

-- Pipeline de análise em múltiplas etapas
-- Crie uma tabela temporária com o total vendido por mês e por ano, uma com a média mensal de vendas por ano e juntando as duas anteriores, contendo apenas os meses onde as vendas superaram a média anual.
-- Por fim, consulte a tabela final exibindo o ano, o mês, o total do mês, a média anual e o quanto o mês superou a média (em valor absoluto e percentual).

create temp table tmp_vendas_mensais as
select
    extract(year from o.order_date) as ano,
    extract(month from o.order_date) as mes,
    sum((od.unit_price * od.quantity) * (1 - od.discount)) as total_vendas
from orders o
inner join order_details od on o.order_id = od.order_id
group by extract(year from o.order_date), extract(month from o.order_date)
order by ano, mes;

create temp table tmp_media_anual as
select
    ano,
    avg(total_vendas) as media_vendas_anual
from tmp_vendas_mensais
group by ano
order by ano;

create temp table tmp_meses_acima_media as
select
    vm.ano,
    vm.mes,
    vm.total_vendas,
    ma.media_vendas_anual
from tmp_vendas_mensais vm
join tmp_media_anual ma on vm.ano = ma.ano
where vm.total_vendas > ma.media_vendas_anual
order by vm.ano, vm.mes;

select
    ano,
    mes,
    total_vendas as total_mes,
    media_vendas_anual as media_anual,
    (total_vendas - media_vendas_anual) as diferenca_absoluta,
    (total_vendas - media_vendas_anual) / media_vendas_anual * 100 as diferenca_percentual
from tmp_meses_acima_media
