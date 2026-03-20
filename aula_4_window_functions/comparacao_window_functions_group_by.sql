-- Comparando funções de agregação com window functions.
-- Usando funções de agregação
SELECT customer_id,
    MIN(freight) AS min_freight,
    MAX(freight) AS max_freight,
    AVG(freight) AS avg_freight
FROM orders
GROUP BY customer_id
ORDER BY customer_id;
-- Usando window functions
SELECT customer_id,
    MIN(freight) OVER (PARTITION BY customer_id) AS min_freight,
    MAX(freight) OVER (PARTITION BY customer_id) AS max_freight,
    AVG(freight) OVER (PARTITION BY customer_id) AS avg_freight
FROM orders
ORDER BY customer_id;
-- Window functions permitem análises linha a linha, como por exemplo, calcular quais pedidos tiveram o custo de frete maior do que o custo médio do frete
SELECT customer_id,
    order_id,
    freight,
    AVG(freight) OVER (PARTITION BY customer_id) AS avg_freight,
    CASE
        WHEN freight > AVG(freight) OVER (PARTITION BY customer_id) THEN 'maior'
        ELSE 'menor'
    END AS comparacao_frete
FROM orders
ORDER BY customer_id;