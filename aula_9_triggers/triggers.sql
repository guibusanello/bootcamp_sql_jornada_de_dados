-- Criação das tabelas e dados para a aula

-- Criação do BD
CREATE DATABASE triggers

-- Criação da tabela Funcionario
CREATE TABLE Funcionario (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(100),
    salario DECIMAL(10, 2),
    dtcontratacao DATE
);

SELECT * FROM funcionario

-- Criação da tabela Funcionario_Auditoria
CREATE TABLE Funcionario_Auditoria (
    id INT,
    salario_antigo DECIMAL(10, 2),
    novo_salario DECIMAL(10, 2),
    data_de_modificacao_do_salario TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id) REFERENCES Funcionario(id)
);

SELECT * FROM funcionario_auditoria

-- Inserção de dados na tabela Funcionario
INSERT INTO Funcionario (nome, salario, dtcontratacao) VALUES ('Maria', 5000.00, '2021-06-01');
INSERT INTO Funcionario (nome, salario, dtcontratacao) VALUES ('João', 4500.00, '2021-07-15');
INSERT INTO Funcionario (nome, salario, dtcontratacao) VALUES ('Ana', 4000.00, '2022-01-10');
INSERT INTO Funcionario (nome, salario, dtcontratacao) VALUES ('Pedro', 5500.00, '2022-03-20');
INSERT INTO Funcionario (nome, salario, dtcontratacao) VALUES ('Lucas', 4700.00, '2022-05-25');

SELECT * FROM funcionario

-- Criação do Trigger para auditoria de alterações de salário
CREATE OR REPLACE FUNCTION registrar_auditoria_salario() RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO Funcionario_Auditoria (id, salario_antigo, novo_salario)
    VALUES (OLD.id, OLD.salario, NEW.salario);
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- nome do trigger
CREATE TRIGGER trg_salario_modificado
-- o que chama ele, se é antes ou depois de alguma ação em qual tabela e coluna
AFTER UPDATE OF salario ON Funcionario 
-- row para fazer alteração de um por um, statement para fazer todas as alterações de uma vez
FOR EACH ROW 
EXECUTE FUNCTION registrar_auditoria_salario();

-- Atualiza o salário da Ana
UPDATE Funcionario SET salario = 4300.00 WHERE nome = 'Ana';

-- Consulta à tabela Funcionario_Auditoria para verificar as mudanças
SELECT * FROM Funcionario_Auditoria WHERE id = (SELECT id FROM Funcionario WHERE nome = 'Ana');

SELECT * FROM Funcionario