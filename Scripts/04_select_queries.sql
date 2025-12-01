-- 1. Consulta básica com WHERE e ORDER BY
SELECT nome, email, categoria, data_cadastro
FROM USUARIO 
WHERE status = 'Ativo'
ORDER BY nome;

-- 2. Consulta com JOIN entre 3 tabelas
SELECT 
    l.titulo AS livro,
    a.nome AS autor,
    e.nome AS editora,
    l.ano_publicacao,
    l.genero
FROM LIVRO l
JOIN ESCREVE es ON l.isbn = es.isbn
JOIN AUTOR a ON es.codigo_autor = a.codigo_autor
JOIN EDITORA e ON l.codigo_editora = e.codigo_editora
ORDER BY l.titulo;

-- 3. Consulta com COUNT e GROUP BY
SELECT 
    categoria,
    COUNT(*) AS total_usuarios,
    AVG(EXTRACT(YEAR FROM AGE(CURRENT_DATE, data_cadastro))) AS tempo_medio_cadastro
FROM USUARIO
GROUP BY categoria
ORDER BY total_usuarios DESC;

-- 4. Consulta com LEFT JOIN e WHERE complexo
SELECT 
    u.nome AS usuario,
    l.titulo AS livro_emprestado,
    emp.data_retirada,
    emp.data_devolucao_prevista,
    CASE 
        WHEN emp.data_devolucao_prevista < CURRENT_DATE THEN 'Em atraso'
        ELSE 'No prazo'
    END AS situacao
FROM EMPRESTIMO emp
JOIN USUARIO u ON emp.codigo_usuario = u.codigo_usuario
JOIN EXEMPLAR ex ON emp.codigo_exemplar = ex.codigo_exemplar
JOIN LIVRO l ON ex.isbn = l.isbn
WHERE emp.status = 'Ativo'
ORDER BY emp.data_devolucao_prevista;

-- 5. Subconsulta e LIMIT
SELECT 
    titulo,
    ano_publicacao,
    (SELECT COUNT(*) FROM EXEMPLAR WHERE isbn = l.isbn) AS total_exemplares
FROM LIVRO l
WHERE ano_publicacao > 1900
ORDER BY total_exemplares DESC
LIMIT 5;

-- 6. Consulta com HAVING
SELECT 
    l.genero,
    COUNT(DISTINCT l.isbn) AS total_livros,
    COUNT(ex.codigo_exemplar) AS total_exemplares
FROM LIVRO l
LEFT JOIN EXEMPLAR ex ON l.isbn = ex.isbn
GROUP BY l.genero
HAVING COUNT(DISTINCT l.isbn) > 0
ORDER BY total_livros DESC;

-- 7. Consulta com date functions
SELECT 
    u.nome,
    emp.data_retirada,
    emp.data_devolucao_prevista,
    emp.data_devolucao_real,
    (emp.data_devolucao_prevista - emp.data_retirada) AS prazo_dias,
    CASE 
        WHEN emp.data_devolucao_real IS NOT NULL THEN
            (emp.data_devolucao_real - emp.data_retirada)
        ELSE NULL
    END AS dias_utilizados
FROM EMPRESTIMO emp
JOIN USUARIO u ON emp.codigo_usuario = u.codigo_usuario
WHERE emp.status IN ('Devolvido', 'Atrasado');

-- 8. Consulta de multas pendentes
SELECT 
    u.nome AS usuario,
    u.email,
    m.valor AS multa,
    m.data_geracao,
    m.motivo,
    l.titulo AS livro_relacionado
FROM MULTA m
JOIN EMPRESTIMO emp ON m.codigo_emprestimo = emp.codigo_emprestimo
JOIN USUARIO u ON emp.codigo_usuario = u.codigo_usuario
JOIN EXEMPLAR ex ON emp.codigo_exemplar = ex.codigo_exemplar
JOIN LIVRO l ON ex.isbn = l.isbn
WHERE m.status = 'Pendente'
ORDER BY m.data_geracao DESC;