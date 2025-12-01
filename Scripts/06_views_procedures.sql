-- Script 06: Views e Stored Procedures
-- 1. VIEW: Livros disponíveis para empréstimo
CREATE OR REPLACE VIEW vw_livros_disponiveis AS
SELECT 
    l.isbn,
    l.titulo,
    a.nome AS autor,
    e.nome AS editora,
    COUNT(ex.codigo_exemplar) AS exemplares_disponiveis,
    MIN(ex.localizacao) AS localizacao
FROM LIVRO l
JOIN ESCREVE es ON l.isbn = es.isbn
JOIN AUTOR a ON es.codigo_autor = a.codigo_autor
JOIN EDITORA e ON l.codigo_editora = e.codigo_editora
JOIN EXEMPLAR ex ON l.isbn = ex.isbn
WHERE ex.status = 'Disponível'
GROUP BY l.isbn, l.titulo, a.nome, e.nome
ORDER BY l.titulo;

-- 2. VIEW: Usuários com multas pendentes
CREATE OR REPLACE VIEW vw_usuarios_com_multas AS
SELECT 
    u.codigo_usuario,
    u.nome,
    u.email,
    u.telefone,
    SUM(m.valor) AS total_devido,
    COUNT(m.codigo_multa) AS multas_pendentes
FROM USUARIO u
JOIN EMPRESTIMO emp ON u.codigo_usuario = emp.codigo_usuario
JOIN MULTA m ON emp.codigo_emprestimo = m.codigo_emprestimo
WHERE m.status = 'Pendente'
GROUP BY u.codigo_usuario, u.nome, u.email, u.telefone
ORDER BY total_devido DESC;

-- 3. VIEW: Estatísticas mensais de empréstimos
CREATE OR REPLACE VIEW vw_estatisticas_mensais AS
SELECT 
    EXTRACT(YEAR FROM data_retirada) AS ano,
    EXTRACT(MONTH FROM data_retirada) AS mes,
    COUNT(*) AS total_emprestimos,
    COUNT(DISTINCT codigo_usuario) AS usuarios_ativos,
    COUNT(DISTINCT codigo_exemplar) AS exemplares_utilizados,
    AVG(data_devolucao_prevista - data_retirada) AS prazo_medio_dias
FROM EMPRESTIMO
GROUP BY EXTRACT(YEAR FROM data_retirada), EXTRACT(MONTH FROM data_retirada)
ORDER BY ano DESC, mes DESC;

-- 4. PROCEDURE: Registrar novo empréstimo
CREATE OR REPLACE PROCEDURE registrar_emprestimo(
    p_codigo_usuario INTEGER,
    p_codigo_exemplar INTEGER
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_prazo_dias INTEGER;
    v_categoria_usuario VARCHAR(20);
BEGIN
    -- Verificar se usuário existe e está ativo
    IF NOT EXISTS (SELECT 1 FROM USUARIO WHERE codigo_usuario = p_codigo_usuario AND status = 'Ativo') THEN
        RAISE EXCEPTION 'Usuário não encontrado ou inativo';
    END IF;
    
    -- Verificar se exemplar está disponível
    IF NOT EXISTS (SELECT 1 FROM EXEMPLAR WHERE codigo_exemplar = p_codigo_exemplar AND status = 'Disponível') THEN
        RAISE EXCEPTION 'Exemplar não disponível para empréstimo';
    END IF;
    
    -- Obter categoria do usuário para definir prazo
    SELECT categoria INTO v_categoria_usuario
    FROM USUARIO 
    WHERE codigo_usuario = p_codigo_usuario;
    
    -- Definir prazo baseado na categoria
    IF v_categoria_usuario = 'Professor' THEN
        v_prazo_dias := 30;
    ELSE
        v_prazo_dias := 15;
    END IF;
    
    -- Inserir empréstimo
    INSERT INTO EMPRESTIMO (
        codigo_usuario, 
        codigo_exemplar, 
        data_retirada, 
        data_devolucao_prevista, 
        status
    ) VALUES (
        p_codigo_usuario,
        p_codigo_exemplar,
        CURRENT_DATE,
        CURRENT_DATE + v_prazo_dias,
        'Ativo'
    );
    
    -- Atualizar status do exemplar
    UPDATE EXEMPLAR 
    SET status = 'Emprestado'
    WHERE codigo_exemplar = p_codigo_exemplar;
    
    COMMIT;
    
    RAISE NOTICE 'Empréstimo registrado com sucesso! Prazo: % dias', v_prazo_dias;
END;
$$;

-- 5. PROCEDURE: Gerar multa por atraso
CREATE OR REPLACE PROCEDURE gerar_multa_atraso(
    p_codigo_emprestimo INTEGER
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_dias_atraso INTEGER;
    v_valor_multa DECIMAL(10,2);
    v_data_prevista DATE;
BEGIN
    -- Obter data de devolução prevista
    SELECT data_devolucao_prevista INTO v_data_prevista
    FROM EMPRESTIMO 
    WHERE codigo_emprestimo = p_codigo_emprestimo;
    
    -- Calcular dias de atraso
    v_dias_atraso := CURRENT_DATE - v_data_prevista;
    
    IF v_dias_atraso <= 0 THEN
        RAISE EXCEPTION 'Empréstimo não está em atraso';
    END IF;
    
    -- Calcular valor da multa (R$ 1,50 por dia de atraso)
    v_valor_multa := v_dias_atraso * 1.50;
    
    -- Inserir multa
    INSERT INTO MULTA (
        codigo_emprestimo,
        valor,
        data_geracao,
        status,
        motivo
    ) VALUES (
        p_codigo_emprestimo,
        v_valor_multa,
        CURRENT_DATE,
        'Pendente',
        CONCAT('Atraso na devolução: ', v_dias_atraso, ' dias')
    );
    
    -- Atualizar status do empréstimo
    UPDATE EMPRESTIMO 
    SET status = 'Atrasado'
    WHERE codigo_emprestimo = p_codigo_emprestimo;
    
    COMMIT;
    
    RAISE NOTICE 'Multa gerada: R$ % por % dias de atraso', v_valor_multa, v_dias_atraso;
END;
$$;

-- 6. FUNCTION: Verificar disponibilidade de livro
CREATE OR REPLACE FUNCTION verificar_disponibilidade_livro(
    p_isbn VARCHAR(13)
)
RETURNS TABLE (
    titulo VARCHAR,
    autor VARCHAR,
    exemplares_disponiveis INTEGER,
    localizacoes TEXT
)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT 
        l.titulo,
        a.nome AS autor,
        COUNT(ex.codigo_exemplar)::INTEGER AS exemplares_disponiveis,
        STRING_AGG(ex.localizacao, ', ') AS localizacoes
    FROM LIVRO l
    JOIN ESCREVE es ON l.isbn = es.isbn
    JOIN AUTOR a ON es.codigo_autor = a.codigo_autor
    LEFT JOIN EXEMPLAR ex ON l.isbn = ex.isbn AND ex.status = 'Disponível'
    WHERE l.isbn = p_isbn
    GROUP BY l.titulo, a.nome;
END;
$$;

-- 7. FUNCTION: Calcular estatísticas de usuário
CREATE OR REPLACE FUNCTION estatisticas_usuario(
    p_codigo_usuario INTEGER
)
RETURNS TABLE (
    total_emprestimos INTEGER,
    livros_distintos INTEGER,
    dias_medio_emprestimo DECIMAL,
    multas_pendentes INTEGER,
    total_devido DECIMAL
)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT 
        COUNT(emp.codigo_emprestimo)::INTEGER AS total_emprestimos,
        COUNT(DISTINCT ex.isbn)::INTEGER AS livros_distintos,
        AVG(emp.data_devolucao_prevista - emp.data_retirada)::DECIMAL AS dias_medio_emprestimo,
        COUNT(m.codigo_multa) FILTER (WHERE m.status = 'Pendente')::INTEGER AS multas_pendentes,
        COALESCE(SUM(m.valor) FILTER (WHERE m.status = 'Pendente'), 0)::DECIMAL AS total_devido
    FROM USUARIO u
    LEFT JOIN EMPRESTIMO emp ON u.codigo_usuario = emp.codigo_usuario
    LEFT JOIN EXEMPLAR ex ON emp.codigo_exemplar = ex.codigo_exemplar
    LEFT JOIN MULTA m ON emp.codigo_emprestimo = m.codigo_emprestimo
    WHERE u.codigo_usuario = p_codigo_usuario
    GROUP BY u.codigo_usuario;
END;
$$;

-- Instruções de uso das views e procedures
SELECT 'Views e Procedures criadas com sucesso!' AS mensagem;
SELECT 'Para usar a view de livros disponíveis: SELECT * FROM vw_livros_disponiveis;' AS exemplo1;
SELECT 'Para registrar um empréstimo: CALL registrar_emprestimo(1, 2);' AS exemplo2;
SELECT 'Para verificar disponibilidade: SELECT * FROM verificar_disponibilidade_livro(''9788532500783'');' AS exemplo3;