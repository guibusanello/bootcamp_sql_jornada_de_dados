-- criação do banco de dados para a aula

CREATE DATABASE sim_itau

-- criação da primeira tabela - clients

CREATE TABLE IF NOT EXISTS clients ( -- usar o if not exists não é obrigatório mas é uma boa prática
    id SERIAL PRIMARY KEY NOT NULL, -- em seguida, tipar as colunas e definir o tipo de dado da coluna. serial primary key dá a responsabilidade de criar os ids para o banco.
    limite INTEGER NOT NULL,
    saldo INTEGER NOT NULL
);

SELECT * FROM clients

-- populando a primeira tabela

INSERT INTO clients (limite, saldo)
VALUES
    (10000, 0),
    (80000, 0),
    (1000000, 0),
    (10000000, 0),
    (500000, 0);

SELECT * FROM clients

-- criação da segunda tabela - transactions

CREATE TABLE IF NOT EXISTS transactions (
    id SERIAL PRIMARY KEY NOT NULL,
    tipo CHAR(1) NOT NULL, -- define c para crédito (entrou dinheiro na conta) e d para débito (saiu dinheiro da conta)
    descricao VARCHAR(20) NOT NULL,
    valor INTEGER NOT NULL,
    cliente_id INTEGER NOT NULL,
    realizada_em TIMESTAMP NOT NULL DEFAULT NOW()
);

SELECT * FROM transactions

-- Simulando uma transação bancária
-- Compra de um Carro, de 80 mil reais, no cliente 1.

INSERT INTO transactions (tipo, descricao, valor, cliente_id)
VALUES ('d', 'Compra de carro', 80000, 1)

UPDATE clients -- seleciona a tabela que deseja alterar
SET saldo = saldo + CASE WHEN 'd' = 'd' THEN -80000 ELSE 80000 END -- alterar valor da coluna conforme desejado
WHERE id = 1; -- Substitua pelo ID do cliente desejado

-- Conferindo o resultado do update

SELECT saldo, limite 
FROM clients
WHERE id = 1

-- Agora, temos uma inconsistência em nosso banco. Uma transação de débito nunca pode deixar o saldo do cliente menor do que o seu limite!
-- No caso acima, temos um saldo de -80000 e um limite de 10000
-- Vamos deletar esse registro

DELETE FROM transactions
WHERE id = 1;

-- Atualizar o registro novamente

UPDATE clients
SET saldo = 0
WHERE id = 1;

SELECT * FROM clients