# Aula 6 - CTE vs Subqueries vs Views vs Temporary Tables vs Materialized Views

## Subquery

**Subqueries são úteis quando você precisa de resultados intermediários para filtrar ou agregar dados em uma consulta principal.**

**USE SUBQUERIES PARA FILTRAR RESULTADOS!**

- Vantagens:
    - São simples de escrever e entender, especialmente para consultas simples.
    - Podem ser aninhadas dentro de outras subqueries ou consultas principais.

- Desvantagens:
    - Pode tornar consultas complexas difíceis de entender e manter.
    - Em algumas situações, podem não ser tão eficientes quanto outras técnicas, especialmente se as subqueries forem executadas várias vezes.

## CTE - Common table expressions

**As CTEs são úteis quando você precisa dividir uma consulta em partes mais gerenciáveis ou quando deseja reutilizar uma subconsulta várias vezes na mesma consulta principal.**

- Vantagens:
    - Permitem escrever consultas mais legíveis e organizadas, dividindo a lógica em partes distintas.
    - Podem ser referenciadas várias vezes na mesma consulta.

- Desvantagens:
    - Podem não ser tão eficientes quanto outras técnicas, especialmente se a CTE for referenciada várias vezes ou se a consulta for muito complexa.

## Views

**As views são úteis quando você precisa reutilizar uma consulta em várias consultas ou quando deseja simplificar consultas complexas dividindo-as em partes menores.**

- Vantagens:
    - Permitem abstrair a lógica de consulta complexa em um objeto de banco de dados reutilizável.
    - Facilitam a segurança, pois você pode conceder permissões de acesso à view em vez das tabelas subjacentes.

- Desvantagens:
    - As views não armazenam dados fisicamente, então elas precisam ser reavaliadas sempre que são consultadas, o que pode impactar o desempenho.
    - Se uma view depende de outras views ou tabelas, a complexidade pode aumentar.

## Temporary tables

**Tabelas temporárias são úteis quando você precisa armazenar dados temporários para uso em uma sessão de banco de dados ou em uma consulta específica.**

- Vantagens:
    - Permitem armazenar resultados intermediários de uma consulta complexa para reutilização posterior.
    - Podem ser indexadas para melhorar o desempenho em consultas subsequentes.

- Desvantagens:
    - Podem consumir recursos do banco de dados, especialmente se forem grandes.
    - Exigem gerenciamento explícito para limpar os dados após o uso.

## Materialized views

**Materialized views são úteis quando você precisa pré-calcular e armazenar resultados de consultas complexas para consultas frequentes ou análises de desempenho.**

- Vantagens:
    - Permitem armazenar fisicamente os resultados de uma consulta, melhorando significativamente o desempenho em consultas subsequentes.
    - Reduzem a carga no banco de dados, já que os resultados são pré-calculados e armazenados.

- Desvantagens:
    - Precisam ser atualizadas regularmente para manter os dados atualizados, o que pode consumir recursos do sistema.
    - A introdução de dados redundantes pode aumentar os requisitos de armazenamento.