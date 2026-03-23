# Exercícios — Window Functions no Northwind (PostgreSQL)

## Funções de classificação

Funções praticadas: `RANK`, `DENSE_RANK`, `ROW_NUMBER`, `PERCENT_RANK`, `NTILE`

---

## Básico — funções individuais

1. **Ranking de vendedores por total de vendas** `RANK`
   Crie um ranking dos funcionários pelo valor total das suas vendas (soma de `UnitPrice * Quantity` em `order_details`). Exiba o nome, total vendido e a posição no ranking. Empates devem deixar lacunas na numeração.

2. **Numeração sequencial de pedidos por cliente** `ROW_NUMBER`
   Para cada cliente, numere seus pedidos em ordem cronológica (pela `OrderDate`). Mostre o ID do cliente, o ID do pedido, a data e o número sequencial do pedido para aquele cliente.

3. **Ranking de produtos sem lacunas por categoria** `DENSE_RANK`
   Dentro de cada categoria, classifique os produtos pelo preço unitário (`UnitPrice`) do maior para o menor. Produtos com o mesmo preço devem receber o mesmo rank, e o próximo deve ser consecutivo (sem lacunas).

4. **Percentual de posição dos clientes por volume de compras** `PERCENT_RANK`
   Calcule o `PERCENT_RANK` de cada cliente com base no valor total gasto. Mostre o nome do cliente, o total gasto e o percentual de posição (formatado de 0 a 100%).

5. **Segmentação de produtos em quartis de preço** `NTILE`
   Divida todos os produtos ativos em 4 grupos iguais com base no `UnitPrice`. Rotule cada quartil como "econômico", "básico", "premium" e "luxo". Mostre o nome do produto, preço e seu segmento.

---

## Intermediário — combinações e filtros

6. **Ranking de produtos por preço dentro de cada categoria** `RANK` `DENSE_RANK`
   Liste todos os produtos exibindo o nome, categoria, preço unitário, o `RANK` e o `DENSE_RANK` pelo preço dentro de cada categoria — ambos na mesma query. Observe nas linhas onde os dois valores diferem o efeito prático de cada função.

7. **Posição relativa dos pedidos por funcionário** `ROW_NUMBER` `PERCENT_RANK`
   Para cada pedido, exiba o nome do funcionário responsável, a data, o valor total do pedido, o número sequencial do pedido dentro da carteira daquele funcionário (`ROW_NUMBER`) e o percentual de posição desse pedido em relação aos demais do mesmo funcionário (`PERCENT_RANK`).

8. **Classificação de clientes por frete médio pago** `RANK` `NTILE`
   Calcule o frete médio por cliente e, na mesma query, exiba o `RANK` de cada cliente pelo frete médio (do maior para o menor) e em qual quartil (`NTILE(4)`) ele se encontra. Mostre ID do cliente, frete médio, ranking e quartil.

---

## Avançado — análises combinadas

9. **Painel completo de produtos por categoria** `DENSE_RANK` `NTILE` `PERCENT_RANK`
   Em uma única query, para cada produto exiba: nome, categoria, preço, o `DENSE_RANK` pelo preço dentro da categoria, o quartil de preço global (`NTILE(4)`) e o `PERCENT_RANK` global pelo preço. O resultado deve permitir comparar a posição do produto dentro da sua categoria versus no catálogo inteiro.

10. **Análise completa de pedidos por funcionário** `ROW_NUMBER` `RANK` `DENSE_RANK` `PERCENT_RANK` `NTILE`
    Em uma única query, aplique as cinco funções sobre os pedidos particionados por funcionário: `ROW_NUMBER` para numeração sequencial por data, `RANK` e `DENSE_RANK` pelo valor do pedido dentro da carteira do funcionário, `PERCENT_RANK` para posição relativa e `NTILE(3)` para classificar os pedidos em baixo, médio e alto valor. O objetivo é ver as cinco funções operando lado a lado sobre o mesmo conjunto.

## Exercícios — Funções de Agregação como Window Functions no Northwind (PostgreSQL)

Funções praticadas: `SUM`, `AVG`, `COUNT`, `MIN`, `MAX`

---

## Básico — funções individuais

1. **Total de vendas acumulado por funcionário** `SUM`
   Para cada pedido, exiba o nome do funcionário, a data, o valor do pedido e o total acumulado de vendas daquele funcionário até aquela data. Use `SUM` como window function com janela crescente ordenada por `order_date`.

2. **Média móvel do frete por cliente** `AVG`
   Para cada pedido, exiba o ID do cliente, a data, o valor do frete e a média de frete considerando todos os pedidos daquele cliente até aquele momento. Use `AVG` com janela acumulada ordenada por `order_date`.

3. **Contagem progressiva de pedidos por funcionário** `COUNT`
   Para cada pedido, exiba o nome do funcionário, a data do pedido e quantos pedidos aquele funcionário havia realizado até aquele momento — incluindo o pedido atual. Use `COUNT` com janela acumulada.

4. **Menor preço praticado por categoria** `MIN`
   Para cada produto, exiba o nome, a categoria, o preço unitário e o menor preço entre todos os produtos daquela categoria. Use `MIN` particionado por categoria sem ordenação na janela.

5. **Maior venda já registrada na carteira do funcionário** `MAX`
   Para cada pedido, exiba o funcionário, o valor do pedido e o maior valor de pedido registrado na carteira daquele funcionário até aquele momento. Use `MAX` com janela acumulada ordenada por `order_date`.

---

## Intermediário — combinações e filtros

6. **Comparação do frete de cada pedido com a média da rota** `AVG` `MIN` `MAX`
   Para cada pedido, exiba o país de destino (`ship_country`), o valor do frete, a média, o menor e o maior frete já enviado para aquele país — tudo na mesma query, particionado por `ship_country` sem ordenação na janela.

7. **Participação percentual de cada produto nas vendas da categoria** `SUM`
   Para cada produto, exiba o nome, a categoria, o total vendido e qual percentual esse total representa sobre o total vendido da categoria inteira. Use `SUM` particionado por categoria sem ordenação para calcular o total da categoria, e divida o total do produto por ele.

8. **Evolução do ticket médio por funcionário ao longo dos pedidos** `AVG` `COUNT`
   Para cada pedido, exiba o funcionário, a data, o valor do pedido, a média acumulada dos valores dos pedidos daquele funcionário até aquela data e a quantidade acumulada de pedidos. Use `AVG` e `COUNT` com janela crescente ordenada por `order_date`.

---

## Avançado — análises combinadas

9. **Painel de desempenho de produtos por categoria** `SUM` `AVG` `MIN` `MAX`
   Para cada produto vendido, exiba o nome, a categoria, o total vendido, e — particionado por categoria — o total vendido pela categoria inteira, a média de vendas dos produtos da categoria, o produto mais vendido e o menos vendido da categoria. Use `SUM`, `AVG`, `MIN` e `MAX` como window functions sem ordenação na janela.

10. **Análise completa de pedidos por funcionário** `SUM` `AVG` `COUNT` `MIN` `MAX`
    Para cada pedido, exiba o funcionário, a data, o valor do pedido e — particionado por funcionário com janela acumulada ordenada por data — o total acumulado de vendas (`SUM`), a média acumulada dos pedidos (`AVG`), a contagem acumulada de pedidos (`COUNT`), o menor valor de pedido registrado até aquela data (`MIN`) e o maior (`MAX`). O objetivo é observar como as cinco funções evoluem linha a linha conforme os pedidos avançam no tempo.


## Exercícios — Funções de séries temporais como Window Functions no Northwind (PostgreSQL)

Funções praticadas: `LEAD`, `LAG`, `FIRST_VALUE`, `LAST_VALUE`

## Básico — funções individuais

1. **Data do próximo pedido de cada cliente** `LEAD`
   Para cada pedido, exiba o ID do cliente, a data do pedido atual e a data do próximo pedido daquele cliente. Quando não houver próximo pedido, exiba `'sem próximo pedido'`. Use `LEAD` particionado por cliente e ordenado por `order_date`.

2. **Data do pedido anterior de cada cliente** `LAG`
   Para cada pedido, exiba o ID do cliente, a data do pedido atual e a data do pedido imediatamente anterior daquele cliente. Quando não houver pedido anterior, exiba `'primeiro pedido'`. Use `LAG` particionado por cliente e ordenado por `order_date`.

3. **Primeiro pedido já feito por cada funcionário** `FIRST_VALUE`
   Para cada pedido, exiba o nome do funcionário, a data do pedido atual e a data do primeiro pedido que aquele funcionário já realizou. Use `FIRST_VALUE` particionado por funcionário e ordenado por `order_date`.

4. **Produto mais caro de cada categoria** `LAST_VALUE`
   Para cada produto, exiba o nome, a categoria, o preço unitário e o maior preço praticado na categoria. Use `LAST_VALUE` particionado por categoria, ordenado por `unit_price`, com frame `ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING`.

5. **Diferença de frete entre pedidos consecutivos do mesmo cliente** `LAG`
   Para cada pedido, exiba o ID do cliente, a data, o valor do frete atual, o frete do pedido anterior e a diferença entre os dois. Use `LAG` particionado por cliente e ordenado por `order_date`.

---

## Intermediário — combinações e filtros

6. **Variação do valor entre pedidos consecutivos por funcionário** `LEAD` `LAG`
   Para cada pedido, exiba o funcionário, a data, o valor do pedido, o valor do pedido anterior (`LAG`) e o valor do próximo pedido (`LEAD`) dentro da carteira daquele funcionário. Use ambas as funções particionadas por funcionário e ordenadas por `order_date`.

7. **Comparação de cada pedido com o primeiro e o último do cliente** `FIRST_VALUE` `LAST_VALUE`
   Para cada pedido, exiba o ID do cliente, a data, o valor do pedido, o valor do primeiro pedido e o valor do último pedido daquele cliente. Use `FIRST_VALUE` e `LAST_VALUE` particionados por cliente, ordenados por `order_date`, com frame `ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING`.

8. **Intervalo em dias entre pedidos consecutivos por cliente** `LAG`
   Para cada pedido, exiba o ID do cliente, a data do pedido atual, a data do pedido anterior e a diferença em dias entre os dois. Use `LAG` particionado por cliente e ordenado por `order_date`. Para calcular a diferença de datas no PostgreSQL use `order_date - LAG(...) OVER (...)`.

---

## Avançado — análises combinadas

9. **Evolução do preço dos produtos ao longo das ordens de compra** `LEAD` `LAG` `FIRST_VALUE`
   Para cada item vendido, exiba o nome do produto, a data do pedido, o preço praticado naquele pedido (`unit_price` de `order_details`), o preço praticado no pedido anterior (`LAG`), o preço praticado no próximo pedido (`LEAD`) e o primeiro preço pelo qual o produto foi vendido (`FIRST_VALUE`). Particione por produto e ordene por `order_date`.

10. **Análise completa de evolução de pedidos por cliente** `LEAD` `LAG` `FIRST_VALUE` `LAST_VALUE`
    Para cada pedido, exiba o ID do cliente, a data, o valor do pedido, o valor do pedido anterior (`LAG`), o valor do próximo pedido (`LEAD`), o valor do primeiro pedido do cliente (`FIRST_VALUE`) e o valor do último pedido do cliente (`LAST_VALUE`). Todas as janelas devem ser particionadas por cliente e ordenadas por `order_date`. Para `LAST_VALUE`, lembre-se de usar o frame `ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING`.