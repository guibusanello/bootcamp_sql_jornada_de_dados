# ACID

ACID (Atomicidade, Consistência, Isolamento e Durabilidade) é um conjunto de propriedades que garante a confiabilidade e integridade das transações em sistemas SQL (bancos de dados relacionais), mesmo diante de falhas. Ele assegura que todas as operações em uma transação sejam concluídas com sucesso, ou nada seja aplicado.

- Atomicidade: A transação é uma unidade única ("tudo ou nada"). Se uma parte falhar, toda a operação é revertida (rollback).
- Consistência: Garante que o banco de dados passe de um estado válido para outro, respeitando regras e restrições (constraints).
- Isolamento: Transações concorrentes não interferem umas nas outras. Cada uma parece ocorrer isoladamente.
- Durabilidade: Uma vez confirmada (commit), a transação é permanente, mesmo em caso de falha de sistema ou queda de energia.

