-- Operadores são essenciais para filtrar registros em tabelas
-- Operadores de comparação =, !=, <, >, <=, >=, BETWEEN, IN, LIKE, IS NULL, IS NOT NULL
-- Operadores lógicos AND, OR, NOT
-- Operadores aritméticos +, -, *, /
-- Operadores de comparação
-- Preços menores que 20
SELECT *
FROM products
WHERE unit_price < 20;
-- Preços maiores ou iguais a 20
SELECT *
FROM products
WHERE unit_price >= 20;
-- Preços diferentes de 20
SELECT *
FROM products
WHERE unit_price != 20;
-- Preços entre 20 e 40
SELECT *
FROM products
WHERE unit_price BETWEEN 20 AND 40;
-- Preços iguais a 20 ou 40
SELECT *
FROM products
WHERE unit_price IN (20, 40);
-- LIKE e NOT LIKE
-- Preços que começam com 'A'
SELECT *
FROM products
WHERE name LIKE 'A%';
-- Preços que terminam com 'A'
SELECT *
FROM products
WHERE name LIKE '%A';
-- Preços que contêm 'A'
SELECT *
FROM products
WHERE name LIKE '%A%';
-- Preços que não começam com 'A'
SELECT *
FROM products
WHERE name NOT LIKE 'A%';
-- Preços que não terminam com 'A'
SELECT *
FROM products
WHERE name NOT LIKE '%A';
-- Preços que não contêm 'A'
SELECT *
FROM products
WHERE name NOT LIKE '%A%';
-- NULL e NOT NULL
-- Selecionar clientes que não tem fax
SELECT *
FROM customers
WHERE fax IS NULL;
-- Selecionar clientes que têm fax
SELECT *
FROM customers
WHERE fax IS NOT NULL;
-- BETWEEN e NOT BETWEEN
-- Selecionar produtos com preço entre 20 e 40
SELECT *
FROM products
WHERE unit_price BETWEEN 20 AND 40;
-- Selecionar produtos com preço fora do intervalo entre 20 e 40
SELECT *
FROM products
WHERE unit_price NOT BETWEEN 20 AND 40;
-- Operadores lógicos
-- AND
-- Selecionar produtos com preço entre 20 e 40 E que começam com 'A'
SELECT *
FROM products
WHERE unit_price BETWEEN 20 AND 40
    AND product_name LIKE 'A%';
-- OR
-- Selecionar produtos com preço entre 20 e 40 OU que começam com 'A'
SELECT *
FROM products
WHERE unit_price BETWEEN 20 AND 40
    OR product_name LIKE 'A%';
-- NOT
-- Selecionar produtos com preço entre 20 e 40 E que NÃO começam com 'A'
SELECT *
FROM products
WHERE unit_price BETWEEN 20 AND 40
    AND NOT product_name LIKE 'A%';