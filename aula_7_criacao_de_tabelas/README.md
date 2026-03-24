# Criação de tabelas e stored procedures

## Criação de tabelas - DDL (Data Definition Language)

### CREATE TABLE

O comando CREATE TABLE é usado para criar uma nova tabela no banco de dados.

O IF NOT EXISTS é uma cláusula opcional que garante que a tabela só será criada se ainda não existir no banco de dados, evitando erros caso a tabela já exista.

Em seguida, é especificada o nome da tabela (clients e transactions neste caso), seguido por uma lista de colunas e suas definições.

Cada coluna é definida com um nome, um tipo de dado e opcionalmente outras restrições, como a definição de uma chave primária (PRIMARY KEY) e a obrigatoriedade de não ser nula (NOT NULL).

### INSERT INTO

O comando INSERT INTO é usado para adicionar novos registros a uma tabela existente.

Na cláusula INSERT INTO, é especificado o nome da tabela (clients neste caso) seguido da lista de colunas entre parênteses, se necessário.

Em seguida, a cláusula VALUES é usada para especificar os valores a serem inseridos nas colunas correspondentes.

Cada linha de valores corresponde a um novo registro a ser inserido na tabela, com os valores na mesma ordem que as colunas foram listadas.

### UUID

UUID é um identificador universalmente exclusivo utilizado para identificação de qualquer coisa no mundo da computação. O UUID é um número de 128 bits representado por 32 dígitos hexadecimais, exibidos em cinco grupos separados por hifens, na forma textual 8-4-4-4-12 sendo um total de 36 caracteres (32 caracteres alfanuméricos e 4 hifens).

Por exemplo: 3d0ca315-aff9–4fc2-be61–3b76b9a2d798

Caso queira usar em produção

```sql
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

CREATE TABLE IF NOT EXISTS clients (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    limite INTEGER NOT NULL,
    saldo INTEGER NOT NULL
);
```

### UPDATE

O comando UPDATE é usado para alterar valores em uma tabela existente.

**Sempre utilize a cláusula WHERE para especificar quais linhas devem ser alteradas; caso contrário, todos os registros da tabela serão atualizados.**

### DELETE

O comando DELETE é uma instrução do SQL usada para remover registros de uma tabela com base em uma condição específica. Ele permite que você exclua dados de uma tabela de banco de dados de forma controlada e precisa.

Aqui estão alguns pontos-chave sobre o comando DELETE:

- **Cláusula WHERE:** A cláusula WHERE é opcional, mas geralmente é usada para especificar quais registros devem ser excluídos. Se não for especificada, todos os registros da tabela serão excluídos.

- **Remoção Condicional:** Você pode usar a cláusula WHERE para definir uma condição para determinar quais registros serão excluídos. Apenas os registros que atendem a essa condição serão removidos.

- **Impacto da Exclusão:** O comando DELETE remove permanentemente os registros da tabela, o que significa que os dados excluídos não podem ser recuperados.

- **Uso Cauteloso:** É importante usar o comando DELETE com cuidado, especialmente sem uma cláusula WHERE específica, pois ele pode resultar na exclusão de todos os registros da tabela.

- **Transações:** Assim como outros comandos SQL de modificação de dados, como INSERT e UPDATE, o comando DELETE pode ser usado dentro de transações para garantir a consistência e a integridade dos dados.

## Stored procedures

Stored Procedures são rotinas armazenadas no banco de dados que contêm uma série de instruções SQL e podem ser executadas por aplicativos ou usuários conectados ao banco de dados. Elas oferecem várias vantagens, como:

1) Reutilização de código: As stored procedures permitem que blocos de código SQL sejam escritos uma vez e reutilizados em várias partes do aplicativo.

2) Desempenho: Por serem compiladas e armazenadas no banco de dados, as stored procedures podem ser executadas de forma mais eficiente do que várias consultas SQL enviadas separadamente pelo aplicativo.

3) Segurança: As stored procedures podem ajudar a proteger o banco de dados, pois os aplicativos só precisam de permissão para executar a stored procedure, não para acessar diretamente as tabelas.

4) Abstração de dados: Elas podem ser usadas para ocultar a complexidade do modelo de dados subjacente, fornecendo uma interface simplificada para os usuários ou aplicativos.

5) Controle de transações: As stored procedures podem incluir instruções de controle de transações para garantir a integridade dos dados durante operações complexas.


Exemplo da aula com comentários:
```sql
-- Criação de uma stored procedure chamada realizar_transacao
CREATE OR REPLACE PROCEDURE realizar_transacao(
    IN p_tipo CHAR(1), -- IN indica que dados vão ENTRAR no banco de dados
    IN p_descricao VARCHAR(10), -- Descrição da transação
    IN p_valor INTEGER, -- Valor da transação
    IN p_cliente_id INTEGER -- ID do cliente
)

-- Definição da linguagem
LANGUAGE plpgsql

-- Corpo da procedure
AS $$ -- O corpo da stored procedure é definido entre AS $$ e $$

DECLARE -- Dentro do corpo, declaramos variáveis locais usando DECLARE
    saldo_atual INTEGER; -- Armazena o saldo atual do cliente
    limite_cliente INTEGER; -- Armazena o limite do cliente
    saldo_apos_transacao INTEGER; -- Armazena o saldo após a transação

BEGIN -- A execução da procedure ocorre entre BEGIN e END

    -- Obtém o saldo atual e o limite do cliente
    SELECT saldo, limite
    INTO saldo_atual, limite_cliente
    FROM clients
    WHERE id = p_cliente_id;

    -- Exibe informações (debug/log)
    RAISE NOTICE 'Saldo atual do cliente: %', saldo_atual; -- print estilo Python
    RAISE NOTICE 'Limite atual do cliente: %', limite_cliente;

    -- Verifica se é débito e se ultrapassa o limite permitido
    IF p_tipo = 'd' AND saldo_atual - p_valor < -limite_cliente THEN
        RAISE EXCEPTION 'Limite insuficiente'; -- Interrompe a execução com erro
    END IF;

    -- Atualiza o saldo do cliente
    UPDATE clients
    SET saldo = saldo + CASE 
        WHEN p_tipo = 'd' THEN -p_valor -- débito subtrai
        ELSE p_valor -- crédito soma
    END
    WHERE id = p_cliente_id;

    -- Insere o registro da transação
    INSERT INTO transactions (tipo, descricao, valor, cliente_id)
    VALUES (p_tipo, p_descricao, p_valor, p_cliente_id);

    -- Obtém o saldo após a transação
    SELECT saldo
    INTO saldo_apos_transacao
    FROM clients
    WHERE id = p_cliente_id;

    -- Exibe o saldo final
    RAISE NOTICE 'Saldo cliente apos transacao: %', saldo_apos_transacao;

END;

$$;
```

### Stored procedures vs views

VIEWS são a materialização de uma query. Viés de consumo de dados.
STORED PROCEDURES também são a materialização de uma query, mas com um viés de inserção, atualização e eliminação de dados.

As Views são abstrações de consulta que permitem aos usuários definir consultas complexas e frequentemente usadas como uma única entidade.
Elas são essencialmente consultas SQL pré-definidas que são armazenadas no banco de dados e tratadas como tabelas virtuais.
As Views simplificam o acesso aos dados, ocultando a complexidade das consultas subjacentes e fornecendo uma interface consistente para os usuários.
Elas são úteis para simplificar consultas frequentes, segmentar permissões de acesso aos dados e abstrair a complexidade do modelo de dados subjacente.

As Stored Procedures são abstrações de transações que consistem em um conjunto de instruções SQL pré-compiladas e armazenadas no banco de dados.
Elas são usadas para encapsular operações de banco de dados mais complexas, como atualizações, inserções, exclusões e outras transações.
As Stored Procedures podem aceitar parâmetros de entrada e retornar valores de saída, o que as torna altamente flexíveis e reutilizáveis em diferentes partes de um aplicativo.
Elas oferecem maior controle sobre as operações de banco de dados e permitem a execução de lógica de negócios no lado do servidor.

