-- Tabela EDITORA
CREATE TABLE IF NOT EXISTS EDITORA (
    codigo_editora SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    site VARCHAR(200),
    pais VARCHAR(50),
    data_cadastro TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabela USUARIO
CREATE TABLE IF NOT EXISTS USUARIO (
    codigo_usuario SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    telefone VARCHAR(15),
    email VARCHAR(100) UNIQUE NOT NULL,
    categoria VARCHAR(20) NOT NULL CHECK (categoria IN ('Aluno', 'Professor', 'Funcionário')),
    data_cadastro DATE DEFAULT CURRENT_DATE,
    status VARCHAR(10) DEFAULT 'Ativo' CHECK (status IN ('Ativo', 'Inativo', 'Suspenso'))
);

-- Tabela AUTOR
CREATE TABLE IF NOT EXISTS AUTOR (
    codigo_autor SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    nacionalidade VARCHAR(50),
    data_nascimento DATE,
    biografia TEXT,
    data_cadastro TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabela LIVRO
CREATE TABLE IF NOT EXISTS LIVRO (
    isbn VARCHAR(13) PRIMARY KEY,
    titulo VARCHAR(200) NOT NULL,
    ano_publicacao INTEGER CHECK (ano_publicacao > 0 AND ano_publicacao <= EXTRACT(YEAR FROM CURRENT_DATE)),
    codigo_editora INTEGER REFERENCES EDITORA(codigo_editora) ON DELETE SET NULL,
    edicao INTEGER CHECK (edicao > 0),
    paginas INTEGER CHECK (paginas > 0),
    genero VARCHAR(50),
    data_cadastro TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabela EXEMPLAR
CREATE TABLE IF NOT EXISTS EXEMPLAR (
    codigo_exemplar SERIAL PRIMARY KEY,
    isbn VARCHAR(13) REFERENCES LIVRO(isbn) ON DELETE CASCADE,
    data_aquisicao DATE DEFAULT CURRENT_DATE,
    status VARCHAR(15) DEFAULT 'Disponível' CHECK (status IN ('Disponível', 'Emprestado', 'Manutenção', 'Reservado')),
    localizacao VARCHAR(50),
    observacoes TEXT,
    data_cadastro TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabela EMPRESTIMO
CREATE TABLE IF NOT EXISTS EMPRESTIMO (
    codigo_emprestimo SERIAL PRIMARY KEY,
    codigo_usuario INTEGER REFERENCES USUARIO(codigo_usuario) ON DELETE RESTRICT,
    codigo_exemplar INTEGER REFERENCES EXEMPLAR(codigo_exemplar) ON DELETE RESTRICT,
    data_retirada DATE DEFAULT CURRENT_DATE,
    data_devolucao_prevista DATE NOT NULL,
    data_devolucao_real DATE,
    status VARCHAR(15) DEFAULT 'Ativo' CHECK (status IN ('Ativo', 'Devolvido', 'Atrasado')),
    data_cadastro TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabela MULTA
CREATE TABLE IF NOT EXISTS MULTA (
    codigo_multa SERIAL PRIMARY KEY,
    codigo_emprestimo INTEGER UNIQUE REFERENCES EMPRESTIMO(codigo_emprestimo) ON DELETE CASCADE,
    valor DECIMAL(10,2) NOT NULL CHECK (valor >= 0),
    data_geracao DATE DEFAULT CURRENT_DATE,
    data_pagamento DATE,
    status VARCHAR(10) DEFAULT 'Pendente' CHECK (status IN ('Pendente', 'Paga')),
    motivo VARCHAR(100),
    data_cadastro TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabela Associativa ESCREVE
CREATE TABLE IF NOT EXISTS ESCREVE (
    isbn VARCHAR(13) REFERENCES LIVRO(isbn) ON DELETE CASCADE,
    codigo_autor INTEGER REFERENCES AUTOR(codigo_autor) ON DELETE CASCADE,
    data_cadastro TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (isbn, codigo_autor)
);

-- Criar índices para performance
CREATE INDEX idx_livro_editora ON LIVRO(codigo_editora);
CREATE INDEX idx_exemplar_isbn ON EXEMPLAR(isbn);
CREATE INDEX idx_exemplar_status ON EXEMPLAR(status);
CREATE INDEX idx_emprestimo_usuario ON EMPRESTIMO(codigo_usuario);
CREATE INDEX idx_emprestimo_exemplar ON EMPRESTIMO(codigo_exemplar);
CREATE INDEX idx_emprestimo_status ON EMPRESTIMO(status);
CREATE INDEX idx_usuario_email ON USUARIO(email);