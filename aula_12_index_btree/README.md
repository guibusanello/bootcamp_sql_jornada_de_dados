# Index e B-tree

## Index

Um index é uma estrutura auxiliar que o banco cria separada da tabela, com o objetivo de acelerar buscas. Sem index, toda vez que você filtra por uma coluna, o banco precisa varrer linha por linha a tabela inteira — o chamado full table scan. Com um index nessa coluna, ele consegue ir direto ao ponto.
A analogia clássica é o índice remissivo de um livro: em vez de ler o livro inteiro para achar a palavra "churn", você vai no índice, vê que ela está nas páginas 42 e 87, e pula direto lá.

Existem vários tipos de índices, incluindo índices de árvore B, índices hash e índices de bitmap. Cada tipo tem suas próprias características e utilizações adequadas.

As vantagens dos índices incluem consultas mais rápidas e eficientes, enquanto as desvantagens incluem custo adicional de armazenamento e sobrecarga de atualização durante operações de inserção, atualização e exclusão.

Para verificar os índices de uma tabela no Postgresql:
```sql
SELECT indexname, indexdef
FROM pg_indexes
WHERE tablename = 'cars';
```

Para criar um índice:
```sql
CREATE INDEX first_name_index ON pessoas(first_name);
```

## B-Tree

A estrutura de dados mais comum por trás dos indexes é a B-Tree (Balanced Tree — árvore balanceada). É basicamente uma árvore hierárquica onde:

O nó raiz contém valores de referência que dividem os dados em intervalos
Os nós intermediários continuam subdividindo
As folhas contêm os valores reais e ponteiros para as linhas na tabela

```bash
                  [300]
                /       \
          [150]           [450]
         /     \         /     \
     [100]   [200]   [400]   [500]
```

O banco percorre essa árvore de cima para baixo, e como ela é balanceada — todos os caminhos têm a mesma profundidade — a busca é sempre O(log n), ou seja, extremamente rápida mesmo com milhões de linhas.