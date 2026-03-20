-- INNER JOIN
-- Isso garante que só obteremos os pedidos que possuem um cliente correspondente e que foram feitos em 1996.
-- Criar um relatório para todos os pedidos realizados em 1996 e seus clientes
SELECT *
FROM orders o
    INNER JOIN customers c ON o.customer_id = c.customer_id
WHERE EXTRACT(
        year
        FROM o.order_date
    ) = 1996;
-- LEFT JOIN
-- Usado quando você quer todos os registros da primeira (esquerda) tabela, com os correspondentes da segunda (direita) tabela. Se não houver correspondência, a segunda tabela terá campos NULL.
-- Criar um relatório que mostra o número de funcionários e clientes de cada cidade que tem funcionários
SELECT e.city,
    COUNT(DISTINCT e.employee_id) AS total_funcionarios,
    COUNT(DISTINCT c.customer_id) AS total_clientes
FROM employees e
    LEFT JOIN customers c ON e.city = c.city
GROUP BY e.city;
-- FULL OUTER JOIN
-- Retorna todos os registros quando há correspondência em uma das tabelas.
-- Criar um relatório que mostra o número de funcionários e clientes de cada cidade
SELECT COALESCE(e.city, c.city) AS cidade,
    COUNT(DISTINCT e.employee_id) AS numero_de_funcionarios,
    COUNT(DISTINCT c.customer_id) AS numero_de_clientes
FROM employees e
    FULL JOIN customers c ON e.city = c.city
GROUP BY e.city,
    c.city
ORDER BY cidade;