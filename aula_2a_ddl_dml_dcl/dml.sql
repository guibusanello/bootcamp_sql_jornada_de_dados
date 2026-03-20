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
-- Inserir dados na tabela
INSERT INTO clientes (
        id,
        nome,
        email,
        telefone,
        data_cadastro,
        ativo,
        cidade,
        estado,
        pais,
        cep
    )
VALUES (
        1,
        'Guilherme Almeida Busarello',
        'email@example.com',
        '5547991010101',
        '2026-03-20',
        TRUE,
        'Joinville',
        'SC',
        'Brasil',
        '89221110'
    );
SELECT *
FROM clientes;
-- Atualizar dados na tabela
UPDATE clientes
SET cidade = 'Frederico Westphalen',
    estado = 'RS',
    cep = '98400000'
WHERE id = 1;
SELECT *
FROM clientes;
-- Deletar dados da tabela
DELETE FROM clientes
WHERE id = 1;
SELECT *
FROM clientes;