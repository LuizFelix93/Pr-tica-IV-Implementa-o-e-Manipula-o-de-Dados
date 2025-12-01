-- Inserir Editoras
INSERT INTO EDITORA (nome, site, pais) VALUES
('Companhia das Letras', 'www.companhiadasletras.com.br', 'Brasil'),
('Editora 34', 'www.editora34.com.br', 'Brasil'),
('HarperCollins', 'www.harpercollins.com', 'EUA'),
('Penguin Random House', 'www.penguinrandomhouse.com', 'EUA'),
('Editora Record', 'www.record.com.br', 'Brasil');

-- Inserir Usuários
INSERT INTO USUARIO (nome, telefone, email, categoria) VALUES
('Maria Silva', '11999998888', 'maria.silva@email.com', 'Aluno'),
('João Santos', '11988887777', 'joao.santos@email.com', 'Professor'),
('Ana Oliveira', '11977776666', 'ana.oliveira@email.com', 'Funcionário'),
('Carlos Mendes', '11966665555', 'carlos.mendes@email.com', 'Aluno'),
('Fernanda Lima', '11955554444', 'fernanda.lima@email.com', 'Professor');

-- Inserir Autores
INSERT INTO AUTOR (nome, nacionalidade, data_nascimento) VALUES
('Clarice Lispector', 'Brasileira', '1920-12-10'),
('Machado de Assis', 'Brasileira', '1839-06-21'),
('Jorge Amado', 'Brasileira', '1912-08-10'),
('George Orwell', 'Britânica', '1903-06-25'),
('Jane Austen', 'Britânica', '1775-12-16');

-- Inserir Livros
INSERT INTO LIVRO (isbn, titulo, ano_publicacao, codigo_editora, edicao, paginas, genero) VALUES
('9788532500783', 'A Hora da Estrela', 1977, 1, 1, 96, 'Romance'),
('9788535911243', 'Dom Casmurro', 1899, 2, 5, 256, 'Romance'),
('9788535909554', 'Capitães da Areia', 1937, 1, 3, 320, 'Romance'),
('9788535914848', '1984', 1949, 3, 10, 328, 'Ficção Científica'),
('9788535919669', 'Orgulho e Preconceito', 1813, 4, 8, 432, 'Romance');

-- Inserir Relacionamentos Livro-Autor
INSERT INTO ESCREVE (isbn, codigo_autor) VALUES
('9788532500783', 1),
('9788535911243', 2),
('9788535909554', 3),
('9788535914848', 4),
('9788535919669', 5);

-- Inserir Exemplares
INSERT INTO EXEMPLAR (isbn, data_aquisicao, status, localizacao) VALUES
('9788532500783', '2023-01-15', 'Disponível', 'A3'),
('9788532500783', '2023-02-20', 'Disponível', 'A3'),
('9788535911243', '2023-03-10', 'Emprestado', 'B1'),
('9788535909554', '2023-04-05', 'Disponível', 'C2'),
('9788535914848', '2023-05-12', 'Manutenção', 'D4'),
('9788535919669', '2023-06-18', 'Disponível', 'E5');

-- Inserir Empréstimos
INSERT INTO EMPRESTIMO (codigo_usuario, codigo_exemplar, data_retirada, data_devolucao_prevista, status) VALUES
(2, 3, '2024-05-01', '2024-06-01', 'Ativo'),
(1, 4, '2024-05-10', '2024-05-25', 'Ativo'),
(3, 1, '2024-04-15', '2024-04-30', 'Devolvido'),
(4, 6, '2024-04-01', '2024-04-16', 'Devolvido');

-- Atualizar datas de devolução real
UPDATE EMPRESTIMO SET data_devolucao_real = '2024-04-30' WHERE codigo_emprestimo = 3;
UPDATE EMPRESTIMO SET data_devolucao_real = '2024-04-16' WHERE codigo_emprestimo = 4;

-- Inserir Multas (apenas para atrasos)
INSERT INTO MULTA (codigo_emprestimo, valor, data_geracao, status, motivo) VALUES
(3, 5.00, '2024-05-01', 'Paga', 'Atraso na devolução - 1 dia');

-- Atualizar data de pagamento
UPDATE MULTA SET data_pagamento = '2024-05-02' WHERE codigo_multa = 1;

-- Confirmar transação
COMMIT;

SELECT 'Dados inseridos com sucesso!' AS mensagem;