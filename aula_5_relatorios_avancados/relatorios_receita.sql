-- Qual foi o total de receitas no ano de 1997?
SELECT SUM(
        (od.unit_price * od.quantity) * (1 - od.discount)
    ) AS total_receitas_1997
FROM order_details od
    JOIN orders o ON od.order_id = o.order_id
WHERE EXTRACT(
        year
        from o.order_date
    ) = '1997' 
    
-- Faça uma análise de crescimento mensal e o cálculo de YTD
    WITH ReceitasMensais AS (
        SELECT EXTRACT(
                YEAR
                FROM orders.order_date
            ) AS Ano,
            EXTRACT(
                MONTH
                FROM orders.order_date
            ) AS Mes,
            SUM(
                order_details.unit_price * order_details.quantity * (1.0 - order_details.discount)
            ) AS Receita_Mensal
        FROM orders
            INNER JOIN order_details ON orders.order_id = order_details.order_id
        GROUP BY EXTRACT(
                YEAR
                FROM orders.order_date
            ),
            EXTRACT(
                MONTH
                FROM orders.order_date
            )
    ),
    ReceitasAcumuladas AS (
        SELECT Ano,
            Mes,
            Receita_Mensal,
            SUM(Receita_Mensal) OVER (
                PARTITION BY Ano
                ORDER BY Mes
            ) AS Receita_YTD
        FROM ReceitasMensais
    )
SELECT Ano,
    Mes,
    Receita_Mensal,
    Receita_Mensal - LAG(Receita_Mensal) OVER (
        PARTITION BY Ano
        ORDER BY Mes
    ) AS Diferenca_Mensal,
    Receita_YTD,
    (
        Receita_Mensal - LAG(Receita_Mensal) OVER (
            PARTITION BY Ano
            ORDER BY Mes
        )
    ) / LAG(Receita_Mensal) OVER (
        PARTITION BY Ano
        ORDER BY Mes
    ) * 100 AS Percentual_Mudanca_Mensal
FROM ReceitasAcumuladas
ORDER BY Ano,
    Mes;