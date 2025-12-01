📚 Sistema de Gestão de Bibliotecas Universitárias (SGBU)

📋 Sobre o Projeto

Implementação completa de um sistema de gestão bibliotecária utilizando PostgreSQL/MySQL, com modelagem normalizada (3FN) e scripts SQL para operações CRUD.

🏗️ Modelagem

Modelo Entidade-Relacionamento (DER) completo

Normalizado até 3ª Forma Normal (3FN)

8 tabelas principais com relacionamentos bem definidos

🛠️ Tecnologias Utilizadas

PostgreSQL 14+ / MySQL 8+

SQL (DDL, DML, DQL, DCL)

Git e GitHub para versionamento

Mermaid.js para documentação

📁 Estrutura do Projeto
text
SGBU/
├── database/
│   ├── schema.sql        # Criação do banco e tabelas
│   ├── inserts.sql       # Dados iniciais
│   ├── queries.sql       # Consultas principais
│   └── procedures.sql    # Stored procedures
├── docs/
│   ├── DER.md           # Diagrama ER
│   └── modelagem.md     # Documentação da modelagem
└── README.md           # Este arquivo

🚀 Como Executar

1. Configuração do Banco
sql
-- PostgreSQL
CREATE DATABASE sgbiblioteca;
\c sgbiblioteca;

-- MySQL
CREATE DATABASE sgbiblioteca;
USE sgbiblioteca;
2. Executar Scripts
bash
# Executar em ordem:
psql -U postgres -d sgbiblioteca -f database/schema.sql
psql -U postgres -d sgbiblioteca -f database/inserts.sql

🔍 Principais Funcionalidades

✅ Cadastro de livros, autores, editoras

✅ Controle de usuários (alunos, professores, funcionários)

✅ Sistema de empréstimos e devoluções

✅ Controle de multas e reservas

✅ Relatórios estatísticos

📊 Tabelas Principais

Livros - Informações dos acervos

Autores - Cadastro de autores

Editoras - Cadastro de editoras

Usuários - Alunos, professores, funcionários

Empréstimos - Controle de retiradas

Devoluções - Registro de devoluções

Reservas - Sistema de reservas

Multas - Controle de penalidades

📝 Exemplo de Uso
sql
-- Consultar livros disponíveis
SELECT titulo, autor, ano_publicacao 
FROM livros 
WHERE disponivel = TRUE;

-- Ver empréstimos ativos de um usuário
SELECT * FROM emprestimos 
WHERE usuario_id = 123 
AND data_devolucao IS NULL;

📄 Licença

Este projeto está sob a licença MIT. Veja o arquivo LICENSE para mais detalhes.

👥 Autores
Luiz felix da Silva Filho - Desenvolvimento inicial
