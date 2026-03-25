# Triggers

Triggers são procedimentos armazenados, que são automaticamente executados ou disparados quando eventos específicos ocorrem em uma tabela ou visão.

Eles são executados em resposta a eventos como INSERT, UPDATE ou DELETE.

## Por que usar triggers em projetos?

- Automatização de tarefas: Para realizar ações automáticas que são necessárias após modificações na base de dados, como manutenção de logs ou atualização de tabelas relacionadas.

- Integridade de dados: Garantir a consistência e a validação de dados ao aplicar regras de negócio diretamente no banco de dados.

## O Uso de Triggers em Engenharia de Dados Atualmente

Atualmente, o uso de **triggers** em Engenharia de Dados é um tema de debate, e a resposta curta é: **sim, eles ainda são usados, mas de forma muito mais criteriosa e específica do que antigamente.**

Na Engenharia de Dados moderna, houve uma migração da lógica de negócio "dentro do banco" (Stored Procedures e Triggers) para "fora do banco" (dbt, Python, Airflow).

Aqui está um resumo de como eles se encaixam no cenário atual:

### 1. Quando ainda se usa (Casos de Sucesso)
*   **Audit Log / CDC Manual:** Criar uma tabela de histórico para rastrear quem alterou o quê e quando. É a forma mais garantida de capturar mudanças sem que a aplicação precise "lembrar" de logar.
*   **Integridade de Dados Crítica:** Garantir regras que não podem ser quebradas de jeito nenhum, independentemente de qual ferramenta ou script esteja inserindo dados.
*   **Manutenção de Campos de Metadados:** Atualizar automaticamente colunas como `updated_at` sempre que uma linha é modificada.

### 2. Por que muitos Engenheiros de Dados evitam?
*   **Lógica "Invisível":** Triggers rodam "por baixo dos panos". Um engenheiro novo pode passar horas tentando entender por que um dado mudou se a regra não estiver documentada ou visível no código da aplicação/pipeline.
*   **Performance:** Triggers são executados na mesma transação que o `INSERT/UPDATE`. Se o trigger for complexo, ele trava a escrita no banco, o que prejudica a escalabilidade em sistemas de alto volume.
*   **Dificuldade de Teste e CI/CD:** É muito mais difícil testar, versionar e fazer o deploy de uma trigger do que de um modelo SQL no **dbt** ou um script Python.
*   **Manutenibilidade:** Debugar uma trigger em produção é consideravelmente mais difícil do que debugar um pipeline tradicional.

### 3. As Alternativas Modernas
Hoje, o que antes era feito com triggers costuma ser resolvido com:
*   **dbt (Data Build Tool):** Para transformações de dados. Em vez de uma trigger atualizar uma tabela agregada em tempo real, o dbt reconstrói a visão de forma atômica e versionada.
*   **CDC (Change Data Capture) como Debezium:** Em vez de uma trigger "avisar" que algo mudou, ferramentas de CDC leem o log binário do PostgreSQL (`WAL - Write Ahead Log`) sem impactar a performance das transações.
*   **Event-Driven Architecture:** Usar ferramentas como Kafka ou RabbitMQ para reagir a mudanças no banco de dados a partir da camada de aplicação.

### Conclusão
Aprender triggers é fundamental para entender como o motor do banco de dados funciona e para resolver problemas em sistemas legados ou em bancos transacionais (OLTP) muito rigorosos. 

No entanto, para **Data Warehouses (OLAP)**, a regra de ouro hoje é: **evite triggers sempre que possível e prefira ferramentas de transformação declarativa (como dbt).**
