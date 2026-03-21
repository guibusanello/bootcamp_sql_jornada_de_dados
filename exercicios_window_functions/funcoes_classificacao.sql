-- Ranking de vendedores sem lacunas por categoria (RANK)

select
    e.first_name || ' ' || e.last_name as employee_name,
    SUM((od.unit_price * od.quantity) * (1 - od.discount)) as receita_funcionario,
    RANK() OVER (order by SUM((od.unit_price * od.quantity) * (1 - od.discount)) desc) as ranking
from employees e
inner join orders o on e.employee_id = o.employee_id
inner join order_details od on o.order_id = od.order_id
group by e.first_name, e.last_name

-- Numeração sequencial de pedidos por cliente (ROW_NUMBER)

select
    c.customer_id,
    c.company_name,
    o.order_id,
    row_number () over (partition by c.customer_id order by o.order_date) as num_pedido
from customers c
inner join orders o on c.customer_id = o.customer_id
group by c.customer_id, c.company_name, o.order_id


-- Ranking de produtos sem lacunas por categoria (DENSE_RANK)

select    
    ct.category_name,
    p.product_name,
    p.unit_price,
    dense_rank () over (partition by ct.category_name order by p.unit_price DESC) as ranking_produtos
from categories ct
inner join products p on ct.category_id = p.category_id
group by ct.category_name, p.product_name, p.unit_price

-- Percentual de posição dos clientes por volume de compras (PERCENT_RANK)

select
    c.company_name,
    SUM((od.unit_price * od.quantity)) as total_gasto_cliente,
    percent_rank () over (order by SUM((od.unit_price * od.quantity) * 100)) as percentil_cliente
from customers c
inner join orders o on c.customer_id = o.customer_id
inner join order_details od on o.order_id = od.order_id
group by c.company_name
order by percentil_cliente desc

-- Segmentação de produtos em quartis de preço (NTILE)

select
    product_name,
    unit_price,
    NTILE(4) OVER (order by unit_price) as quartil_produto,
    case
        when NTILE(4) OVER (order by unit_price) = 1 then 'econômico'
        when NTILE(4) OVER (order by unit_price) = 2 then 'básico'
        when NTILE(4) OVER (order by unit_price) = 3 then 'premium'
        else 'luxo'
        end as classificacao_produto
from products
where discontinued = 0

-- Ranking de produtos por preço dentro de cada categoria (RANK e DENSE_RANK)

select
    product_name,
    unit_price,
    rank () over (partition by category_id order by unit_price) as ranking_rank,
    dense_rank () over (partition by category_id order by unit_price) as ranking_dense_rank
from products

-- Posição relativa dos pedidos por funcionário (ROW_NUMBER e PERCENT_RANK)

select
    o.order_id,
    e.first_name || ' ' || e.last_name as nome_funcionario,
    o.order_date,
    SUM((od.unit_price * od.quantity) * (1 - od.discount)) as total_pedido,
    ROW_NUMBER () over (partition by e.first_name || ' ' || e.last_name order by o.order_date, o.order_id) as ordem_pedido,
    percent_rank () over (partition by e.first_name || ' ' || e.last_name order by o.order_date, o.order_id) as porcentagem_pedido
from employees e
inner join orders o on e.employee_id = o.employee_id
inner join order_details od on o.order_id = od.order_id
group by o.order_id, e.first_name, e.last_name, o.order_date

-- Classificação de clientes por frete médio pago (RANK e NTILE)

select
    c.customer_id,
    c.company_name,
    AVG(o.freight) as media_frete_cliente,
    rank () over (order by avg(o.freight) desc) as ranking_frete,
    ntile (4) over (order by avg(o.freight) desc) as quartil_frete
from customers c
inner join orders o on c.customer_id = o.customer_id
group by c.customer_id, c.company_name
order by media_frete_cliente desc

-- Painel completo de produtos por categoria (DENSE_RANK, RANK e PERCENT_RANK)

select
    p.product_name,
    ct.category_name,
    p.unit_price,
    dense_rank() over (partition by ct.category_name order by p.unit_price desc) as ranking_produto_categoria,
    ntile(4) over (order by p.unit_price) as quartil_preco_global,
    percent_rank() over (order by p.unit_price) * 100 as percentual_global
from categories ct
inner join products p on ct.category_id = p.category_id

-- Análise completa de pedidos por funcionário (ROW_NUMBER, RANK, DENSE_RANK, PERCENT_RANK e NTILE)

select
    e.first_name || ' ' || e.last_name as funcionario,
    o.order_id,
    SUM((od.quantity * od.unit_price) * (1 - od.discount)) as total_pedido,
    row_number () over (partition by e.employee_id order by o.order_date, o.order_id) as num_pedido_sequencial,
    rank () over (partition by e.employee_id order by SUM((od.quantity * od.unit_price) * (1 - od.discount)) desc) as ranking_rank,
    dense_rank () over (partition by e.employee_id order by SUM((od.quantity * od.unit_price) * (1 - od.discount)) desc) as ranking_dense_rank,
    percent_rank () over (partition by e.employee_id order by SUM((od.quantity * od.unit_price) * (1 - od.discount))) as porcentagem_relativa,
    ntile(3) over (partition by e.employee_id order by SUM((od.quantity * od.unit_price) * (1 - od.discount))) as tercil,
    case
        when ntile(3) over (partition by e.employee_id order by SUM((od.quantity * od.unit_price) * (1 - od.discount))) = 1 then 'baixo'
        when ntile(3) over (partition by e.employee_id order by SUM((od.quantity * od.unit_price) * (1 - od.discount))) = 2 then 'médio'
        else 'alto'
        end as faixa_de_valor
from employees e
inner join orders o on e.employee_id = o.employee_id
inner join order_details od on o.order_id = od.order_id
group by e.employee_id, e.first_name || ' ' || e.last_name, o.order_id