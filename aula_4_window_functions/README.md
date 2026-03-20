## Aula 4 - Window Functions

As Windows Function permitem uma análise de dados eficiente e precisa, ao possibilitar cálculos dentro de partições ou linhas específicas. Elas são cruciais para tarefas como classificação, agregação e análise de tendências em consultas SQL.

Essas funções são aplicadas a cada linha de um conjunto de resultados, e utilizam uma cláusula OVER() para determinar como cada linha é processada dentro de uma "janela", permitindo controle sobre o comportamento da função dentro de um grupo de dados ordenados.

### Sintaxe

```sql
window_function_name(arg1, arg2, ...) OVER (
  [PARTITION BY partition_expression, ...]
  [ORDER BY sort_expression [ASC | DESC], ...]
)
```
- window_function_name: Este é o nome da função de janela que você deseja usar, como SUM, RANK, LEAD, etc.

- arg1, arg2, ...: Estes são os argumentos que você passa para a função de janela, se ela exigir algum. Por exemplo, para a função SUM, você especificaria a coluna que deseja somar.

- OVER: Principal conceito das windows functions, ele que cria essa "Janela" onde fazem nossos cálculos

- PARTITION BY: Esta cláusula opcional divide o conjunto de resultados em partições ou grupos. A função de janela opera independentemente dentro de cada partição.

- ORDER BY: Esta cláusula opcional especifica a ordem em que as linhas são processadas dentro de cada partição. Você pode especificar a ordem ascendente (ASC) ou descendente (DESC).

### Tipos de Funções de Janela

As funções de janela podem ser divididas em três categorias principais:

- Funções de Classificação: RANK, DENSE_RANK, ROW_NUMBER, PERCENT_RANK, NTILE
- Funções de Agregação: SUM, AVG, COUNT, MIN, MAX
- Funções de Análise de Séries Temporais: LEAD, LAG, FIRST_VALUE, LAST_VALUE

### Funções de Classificação

- RANK(): Atribui uma classificação única a cada linha dentro de uma partição, baseada na ordem especificada. **Se houver empates, as linhas empatadas recebem a mesma classificação e a próxima classificação é pulada.**

- DENSE_RANK(): Atribui uma classificação única a cada linha dentro de uma partição, baseada na ordem especificada. **Se houver empates, as linhas empatadas recebem a mesma classificação e a próxima classificação não é pulada.**

- ROW_NUMBER(): Atribui um número único a cada linha dentro de uma partição, baseada na ordem especificada. **Se houver empates, as linhas empatadas recebem números diferentes.**

- PERCENT_RANK(): Atribui uma classificação única a cada linha dentro de uma partição, baseada na ordem especificada. **Se houver empates, as linhas empatadas recebem a mesma classificação e a próxima classificação é pulada.**

- NTILE(): Divide o conjunto de resultados em um número especificado de grupos (n) e atribui a cada linha o número do grupo ao qual pertence.


### Funções de Agregação

- SUM(): Calcula a soma dos valores em uma coluna dentro de uma partição.

- AVG(): Calcula a média dos valores em uma coluna dentro de uma partição.

- COUNT(): Conta o número de linhas em uma partição.

- MIN(): Calcula o valor mínimo em uma coluna dentro de uma partição.

- MAX(): Calcula o valor máximo em uma coluna dentro de uma partição.


### Funções de Análise de Séries Temporais

- LEAD(): Retorna o valor de uma coluna na linha seguinte dentro de uma partição.

- LAG(): Retorna o valor de uma coluna na linha anterior dentro de uma partição.

- FIRST_VALUE(): Retorna o valor da primeira linha em uma partição.

- LAST_VALUE(): Retorna o valor da última linha em uma partição.



