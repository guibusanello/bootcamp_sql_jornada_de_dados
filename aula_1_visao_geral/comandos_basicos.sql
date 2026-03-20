-- Exibir todos os dados da tabela Customers
SELECT *
FROM Customers;
-- Selecionar somente uma coluna específica
-- Mostrar o nome de contato e a cidade dos clientes
SELECT contact_name,
    city
FROM Customers;
-- Usando DISTINCT para selecionar valores distintos
-- Liste todos os países dos clientes
SELECT DISTINCT country
FROM Customers;
-- Usando WHERE para filtrar registros
-- Selecionar todos os clientes do México
SELECT *
FROM Customers
WHERE country = 'Mexico';
-- Seleciona clientes com o ID específico
SELECT *
FROM customers
WHERE customer_id = 'ANATR' -- Utilizar o AND para múltiplos critérios
SELECT *
FROM customers
WHERE country = 'Brazil'
    AND city = 'Sao Paulo';
-- Utilizar o OR para múltiplos critérios
SELECT *
FROM customers
WHERE country = 'Brazil'
    AND city = 'Sao Paulo'
    OR city = 'Rio de Janeiro';
-- Utilizar o NOT para excluir registros
SELECT *
FROM customers
WHERE country NOT IN ('Germany');
-- Utilizar o BETWEEN para selecionar registros dentro de um intervalo
SELECT *
FROM products
WHERE unit_price BETWEEN 10 AND 20;
-- Utilizando o ORDER BY para ordenar resultados
-- Ordenar clientes pelo país em ordem crescente
SELECT *
FROM customers
ORDER BY country ASC;
-- Ordenar clientes pelo país em ordem decrescente
SELECT *
FROM customers
ORDER BY country DESC;
-- Ordenar por país e nome do contato
SELECT *
FROM customers
ORDER BY country,
    contact_name;
-- Ordenar por país em ordem crescente e nome do contato em ordem decrescente
SELECT *
FROM customers
ORDER BY country ASC,
    contact_name DESC;
-- Utilizando o LIKE e o IN
-- Clientes que começam com a letra A
SELECT *
FROM customers
WHERE company_name LIKE 'A%';
-- Clientes com nome de contato não começando com a letra A
SELECT *
FROM customers
WHERE contact_name NOT LIKE 'A%';
-- Clientes de países específicos
SELECT *
FROM customers
WHERE country IN ('Brazil', 'Argentina')
ORDER BY country;
-- Clientes não localizados na Alemanha e França
SELECT *
FROM customers
WHERE country NOT IN ('Germany', 'France');