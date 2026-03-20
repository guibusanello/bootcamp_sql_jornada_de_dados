-- DDL: Data Definition Language
-- Criar um banco de dados
CREATE DATABASE db_teste;
-- Criar uma tabela
CREATE TABLE clientes (
    id INT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL,
    telefone VARCHAR(20) NOT NULL,
    data_cadastro DATE NOT NULL,
    ativo BOOLEAN NOT NULL DEFAULT TRUE,
    cidade VARCHAR(100) NOT NULL,
    estado VARCHAR(2) NOT NULL,
    pais VARCHAR(100) NOT NULL,
    cep VARCHAR(8) NOT NULL
);
-- Verificar os tipos de dados das colunas
SELECT column_name,
    data_type,
    character_maximum_length,
    numeric_precision,
    is_nullable
FROM information_schema.columns
WHERE table_name = 'clientes';
-- Adicionar uma coluna na tabela
ALTER TABLE clientes
ADD COLUMN data_nascimento DATE NOT NULL;
SELECT *
FROM clientes;
-- Modificar uma coluna na tabela
ALTER TABLE clientes
    RENAME COLUMN data_nascimento TO nascimento
ALTER TABLE clientes
ALTER COLUMN nascimento
SET NOT NULL;
SELECT *
FROM clientes;
-- Remover uma coluna da tabela
ALTER TABLE clientes DROP COLUMN nascimento;
SELECT *
FROM clientes;
-- Usando TRUNCATE para remover todos os registros de uma tabela
TRUNCATE TABLE clientes;
-- Remover uma tabela
DROP TABLE clientes;
-- Remover um banco de dados
DROP DATABASE db_teste;