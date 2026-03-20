-- Criar um usuário
CREATE USER usuario WITH PASSWORD 'senha';
-- Conceder permissão a um usuário
GRANT SELECT ON customers TO usuario;
-- Revogar permissão a um usuário
REVOKE
SELECT ON customers
FROM usuario;
-- Remover um usuário
DROP USER usuario;