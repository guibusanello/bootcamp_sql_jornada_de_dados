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


