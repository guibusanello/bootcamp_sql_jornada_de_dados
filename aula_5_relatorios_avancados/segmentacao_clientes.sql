-- Qual é o valor total que cada cliente já pagou até agora?
select c.customer_id,
    c.company_name,
    SUM(
        (od.unit_price * od.quantity) * (1 - od.discount)
    ) AS receita_por_cliente
from customers c
    INNER JOIN orders o ON c.customer_id = o.customer_id
    INNER JOIN od od ON o.order_id = od.order_id
group by c.customer_id,
    c.company_name
order by receita_por_cliente desc 

-- Separe os clientes em 5 grupos de acordo com o valor pago por cliente
select c.customer_id,
    c.company_name,
    SUM(
        (od.unit_price * od.quantity) * (1 - od.discount)
    ) AS receita_por_cliente,
    NTILE(5) OVER (
        ORDER BY SUM(
                od.unit_price * od.quantity * (1.0 - od.discount)
            ) DESC
    ) AS classificacao_cliente
from customers c
    INNER JOIN orders o ON c.customer_id = o.customer_id
    INNER JOIN order_details od ON o.order_id = od.order_id
group by c.customer_id,
    c.company_name
order by receita_por_cliente desc 

-- Agora somente os clientes que estão nos grupos 3, 4 e 5 para que seja feita uma análise de Marketing especial com eles.
    WITH classificacao AS (
        select c.customer_id,
            c.company_name,
            SUM(
                (od.unit_price * od.quantity) * (1 - od.discount)
            ) AS receita_por_cliente,
            NTILE(5) OVER (
                ORDER BY SUM(
                        od.unit_price * od.quantity * (1.0 - od.discount)
                    ) DESC
            ) AS classificacao_clientes
        from customers c
            INNER JOIN orders o ON c.customer_id = o.customer_id
            INNER JOIN order_details od ON o.order_id = od.order_id
        group by c.customer_id,
            c.company_name
        order by receita_por_cliente desc
    )
SELECT *
FROM classificacao
WHERE classificacao_clientes IN (3, 4, 5)