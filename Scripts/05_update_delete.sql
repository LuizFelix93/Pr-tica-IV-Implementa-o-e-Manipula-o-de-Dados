-- Script 05: Comandos UPDATE e DELETE
-- 1. UPDATE: Atualizar status de usuário
UPDATE USUARIO 
SET status = 'Inativo'
WHERE email = 'carlos.mendes@email.com';

-- 2. UPDATE: Atualizar data de devolução real
UPDATE EMPRESTIMO 
SET data_devolucao_real = CURRENT_DATE,
    status = 'Devolvido'
WHERE codigo_emprestimo = 2;

-- 3. UPDATE: Aplicar acréscimo em multa pendente
UPDATE MULTA 
SET valor = valor * 1.1  -- 10% de acréscimo
WHERE status = 'Pendente'
AND data_geracao < CURRENT_DATE - INTERVAL '7 days';

-- 4. UPDATE: Alterar localização de exemplar
UPDATE EXEMPLAR 
SET localizacao = 'Corredor F, Prateleira 6'
WHERE codigo_exemplar = 5;

-- 5. UPDATE: Corrigir categoria de usuário
UPDATE USUARIO 
SET categoria = 'Funcionário'
WHERE nome = 'Ana Oliveira'
AND categoria = 'Professor';

-- 6. DELETE: Remover multas pagas antigas
DELETE FROM MULTA 
WHERE status = 'Paga'
AND data_pagamento < '2024-01-01';

-- 7. DELETE: Remover exemplares perdidos/danificados
DELETE FROM EXEMPLAR 
WHERE status = 'Manutenção'
AND observacoes LIKE '%irrecuperável%';

-- 8. DELETE: Remover usuários inativos sem histórico
DELETE FROM USUARIO 
WHERE status = 'Inativo'
AND codigo_usuario NOT IN (
    SELECT DISTINCT codigo_usuario 
    FROM EMPRESTIMO
);

-- 9. UPDATE: Marcar empréstimos como atrasados
UPDATE EMPRESTIMO 
SET status = 'Atrasado'
WHERE status = 'Ativo'
AND data_devolucao_prevista < CURRENT_DATE;

-- 10. UPDATE: Reativar usuários com mais de 1 ano inativos
UPDATE USUARIO 
SET status = 'Ativo'
WHERE status = 'Inativo'
AND data_cadastro > CURRENT_DATE - INTERVAL '2 years'
AND codigo_usuario IN (
    SELECT codigo_usuario 
    FROM EMPRESTIMO 
    WHERE data_retirada > CURRENT_DATE - INTERVAL '3 months'
);

-- Verificar alterações
SELECT 'Operações UPDATE e DELETE concluídas!' AS resultado;
SELECT COUNT(*) AS usuarios_inativos FROM USUARIO WHERE status = 'Inativo';
SELECT COUNT(*) AS emprestimos_atrasados FROM EMPRESTIMO WHERE status = 'Atrasado';
SELECT COUNT(*) AS multas_atualizadas FROM MULTA WHERE valor > 5.00;