# 🗃️ Modelo Lógico - Esquema Relacional

## 1. Transformação do Modelo Conceitual para Lógico

O modelo lógico representa a **implementação concreta** do banco de dados, transformando entidades em tabelas e relacionamentos em chaves estrangeiras.

## 2. Tabelas e Esquema Relacional

### 2.1. EDITORA
```sql
CREATE TABLE EDITORA (
    codigo_editora SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    site VARCHAR(200),
    pais VARCHAR(50),
    data_cadastro TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

###2.2. USUARIO
CREATE TABLE USUARIO (
    codigo_usuario SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    telefone VARCHAR(15),
    email VARCHAR(100) UNIQUE NOT NULL,
    categoria VARCHAR(20) NOT NULL 
        CHECK (categoria IN ('Aluno', 'Professor', 'Funcionário')),
    data_cadastro DATE DEFAULT CURRENT_DATE,
    status VARCHAR(10) DEFAULT 'Ativo'
        CHECK (status IN ('Ativo', 'Inativo', 'Suspenso'))
);
###2.3. AUTOR
CREATE TABLE AUTOR (
    codigo_autor SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    nacionalidade VARCHAR(50),
    data_nascimento DATE,
    biografia TEXT,
    data_cadastro TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
###2.4. LIVRO
CREATE TABLE LIVRO (
    isbn VARCHAR(13) PRIMARY KEY,
    titulo VARCHAR(200) NOT NULL,
    ano_publicacao INTEGER 
        CHECK (ano_publicacao > 0 AND ano_publicacao <= EXTRACT(YEAR FROM CURRENT_DATE)),
    codigo_editora INTEGER REFERENCES EDITORA(codigo_editora) ON DELETE SET NULL,
    edicao INTEGER CHECK (edicao > 0),
    paginas INTEGER CHECK (paginas > 0),
    genero VARCHAR(50),
    data_cadastro TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
###2.5. EXEMPLAR
CREATE TABLE EXEMPLAR (
    codigo_exemplar SERIAL PRIMARY KEY,
    isbn VARCHAR(13) REFERENCES LIVRO(isbn) ON DELETE CASCADE,
    data_aquisicao DATE DEFAULT CURRENT_DATE,
    status VARCHAR(15) DEFAULT 'Disponível'
        CHECK (status IN ('Disponível', 'Emprestado', 'Manutenção', 'Reservado')),
    localizacao VARCHAR(50),
    observacoes TEXT,
    data_cadastro TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
###2.6. EMPRESTIMO
CREATE TABLE EMPRESTIMO (
    codigo_emprestimo SERIAL PRIMARY KEY,
    codigo_usuario INTEGER REFERENCES USUARIO(codigo_usuario) ON DELETE RESTRICT,
    codigo_exemplar INTEGER REFERENCES EXEMPLAR(codigo_exemplar) ON DELETE RESTRICT,
    data_retirada DATE DEFAULT CURRENT_DATE,
    data_devolucao_prevista DATE NOT NULL,
    data_devolucao_real DATE,
    status VARCHAR(15) DEFAULT 'Ativo'
        CHECK (status IN ('Ativo', 'Devolvido', 'Atrasado')),
    data_cadastro TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT ck_datas_validas 
        CHECK (data_retirada <= data_devolucao_prevista AND 
              (data_devolucao_real IS NULL OR data_retirada <= data_devolucao_real))
);
###2.7. MULTA
CREATE TABLE MULTA (
    codigo_multa SERIAL PRIMARY KEY,
    codigo_emprestimo INTEGER UNIQUE REFERENCES EMPRESTIMO(codigo_emprestimo) ON DELETE CASCADE,
    valor DECIMAL(10,2) NOT NULL CHECK (valor >= 0),
    data_geracao DATE DEFAULT CURRENT_DATE,
    data_pagamento DATE,
    status VARCHAR(10) DEFAULT 'Pendente'
        CHECK (status IN ('Pendente', 'Paga', 'Cancelada')),
    motivo VARCHAR(100),
    data_cadastro TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT ck_data_pagamento_valida 
        CHECK (data_pagamento IS NULL OR data_geracao <= data_pagamento)
);
###2.8. ESCREVE (Tabela Associativa)
CREATE TABLE ESCREVE (
    isbn VARCHAR(13) REFERENCES LIVRO(isbn) ON DELETE CASCADE,
    codigo_autor INTEGER REFERENCES AUTOR(codigo_autor) ON DELETE CASCADE,
    data_cadastro TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (isbn, codigo_autor)
);
###3.1. Índices Primários
Todas as PKs são automaticamente indexadas

###3.2. Índices Secundários
-- Para consultas frequentes por editora
CREATE INDEX idx_livro_editora ON LIVRO(codigo_editora);

-- Para busca de exemplares por livro
CREATE INDEX idx_exemplar_isbn ON EXEMPLAR(isbn);

-- Para consultas de status
CREATE INDEX idx_exemplar_status ON EXEMPLAR(status);

-- Para consultas de empréstimos por usuário
CREATE INDEX idx_emprestimo_usuario ON EMPRESTIMO(codigo_usuario);

-- Para consultas de empréstimos por exemplar
CREATE INDEX idx_emprestimo_exemplar ON EMPRESTIMO(codigo_exemplar);

-- Para consultas de status de empréstimo
CREATE INDEX idx_emprestimo_status ON EMPRESTIMO(status);

-- Para busca por email de usuário
CREATE INDEX idx_usuario_email ON USUARIO(email);

-- Para consultas por categoria
CREATE INDEX idx_usuario_categoria ON USUARIO(categoria);

###3.3. Índices Especiais
-- Para consultas por período (otimização)
CREATE INDEX idx_emprestimo_datas ON EMPRESTIMO(data_retirada, data_devolucao_prevista);

-- Para consultas textuais (PostgreSQL específico)
CREATE INDEX idx_livro_titulo_trgm ON LIVRO USING gin (titulo gin_trgm_ops);
CREATE INDEX idx_usuario_nome_trgm ON USUARIO USING gin (nome gin_trgm_ops);

5. Plano de Execução das Consultas

###5.1. Consulta de Livros Disponíveis
EXPLAIN ANALYZE
SELECT l.titulo, a.nome, COUNT(e.codigo_exemplar)
FROM LIVRO l
JOIN ESCREVE es ON l.isbn = es.isbn
JOIN AUTOR a ON es.codigo_autor = a.codigo_autor
JOIN EXEMPLAR e ON l.isbn = e.isbn
WHERE e.status = 'Disponível'
GROUP BY l.isbn, l.titulo, a.nome;

###5.2. Consulta de Empréstimos em Atraso
EXPLAIN ANALYZE
SELECT u.nome, l.titulo, emp.data_devolucao_prevista
FROM EMPRESTIMO emp
JOIN USUARIO u ON emp.codigo_usuario = u.codigo_usuario
JOIN EXEMPLAR ex ON emp.codigo_exemplar = ex.codigo_exemplar
JOIN LIVRO l ON ex.isbn = l.isbn
WHERE emp.status = 'Ativo'
AND emp.data_devolucao_prevista < CURRENT_DATE;

6. Estratégia de Particionamento

###6.1. Particionamento por Data (Futuro)
-- Exemplo de particionamento para tabela EMPRESTIMO
CREATE TABLE emprestimo_2024 PARTITION OF emprestimo
FOR VALUES FROM ('2024-01-01') TO ('2025-01-01');

CREATE TABLE emprestimo_2025 PARTITION OF emprestimo
FOR VALUES FROM ('2025-01-01') TO ('2026-01-01');

###6.2. Benefícios do Particionamento
Melhor performance em consultas históricas

Facilidade no gerenciamento de backups

Exclusão rápida de dados antigos

Otimização do cache

7. Políticas de Manutenção

###7.1. VACUUM
-- Manutenção diária
VACUUM ANALYZE EMPRESTIMO;
VACUUM ANALYZE EXEMPLAR;

-- Manutenção semanal completa
VACUUM FULL VERBOSE ANALYZE;

###7.3. Atualização de Estatísticas
-- Atualização após grandes inserções
ANALYZE VERBOSE;

8. Considerações de Performance

###8.1. Estatísticas Esperadas
Tabela USUARIO: ~8.000 registros

Tabela LIVRO: ~50.000 registros

Tabela EXEMPLAR: ~60.000 registros

Tabela EMPRESTIMO: ~200.000 registros/ano

Tabela MULTA: ~5.000 registros/ano

###8.2. Tempos de Resposta Alvo
Consultas simples: < 100ms

Consultas com JOINs: < 500ms

Relatórios complexos: < 2s

Inserções/Updates: < 50ms

###8.3. Recomendações de Hardware
RAM: 8GB mínimo (16GB recomendado)

CPU: 4 cores mínimo

Storage: SSD obrigatório

Backup: Espaço para 30 dias de retenção

Status do Modelo: ✅ IMPLEMENTADO
SGBD Alvo: PostgreSQL 14+
Próxima Revisão: Após 6 meses de operação