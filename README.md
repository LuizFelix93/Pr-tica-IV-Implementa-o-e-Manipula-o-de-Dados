# Pratica-IV-Implemento-e-Manipulação-de-Dados
# 📚 Sistema de Gestão de Bibliotecas Universitárias (SGBU)

## 📋 Sobre o Projeto
Implementação completa de um sistema de gestão bibliotecária utilizando PostgreSQL/MySQL, com modelagem normalizada (3FN) e scripts SQL para operações CRUD.

## 🏗️ Modelagem
- Modelo Entidade-Relacionamento (DER) completo
- Normalizado até 3ª Forma Normal (3FN)
- 8 tabelas principais com relacionamentos bem definidos

## 🛠️ Tecnologias Utilizadas
- PostgreSQL 14+ / MySQL 8+
- SQL (DDL, DML, DQL, DCL)
- Git e GitHub para versionamento
- Mermaid.js para documentação

## 📁 Estrutura do Projeto
biblioteca-sgbd/
├── scripts/
│ ├── 01_create_database.sql
│ ├── 02_create_tables.sql
│ ├── 03_insert_data.sql
│ ├── 04_select_queries.sql
│ ├── 05_update_delete.sql
│ └── 06_views_procedures.sql
├── docs/
│ ├── 01_minimundo.md
│ ├── 02_modelo_conceitual.md
│ ├── 03_modelo_logico.md
│ ├── 04_verificacao_normalizacao.md
│ └── 05_der_diagram.md
├── data/
│ └── sample_data.csv
└── README.md

📊 Modelo de Dados
8 Tabelas principais: USUARIO, LIVRO, AUTOR, EXEMPLAR, EMPRESTIMO, MULTA, EDITORA, ESCREVE

Normalização: 3ª Forma Normal (3FN) verificada

Relacionamentos: 10+ relações com cardinalidades definidas

Índices: Otimizados para performance

✨ Funcionalidades Implementadas
✅ Criação do banco de dados e tabelas (DDL)

✅ Inserção de dados de exemplo (DML)

✅ Consultas complexas com JOINs e subconsultas (DQL)

✅ Atualização e exclusão de dados com condições

✅ Views e Stored Procedures

✅ Controle de transações e integridade referencial

🔧 Scripts Disponíveis
Script	Descrição
01_create_database.sql	Criação do banco de dados
02_create_tables.sql	Criação das tabelas com constraints
03_insert_data.sql	Povoamento inicial com dados de exemplo
04_select_queries.sql	Consultas SELECT com diferentes complexidades
05_update_delete.sql	Comandos UPDATE e DELETE com condições
06_views_procedures.sql	Views e Stored Procedures úteis
📚 Documentação Técnica
Consulte a pasta docs/ para:

Descrição detalhada do minimundo

Modelo conceitual e lógico

Verificação completa das formas normais

Diagrama ER interativo

🧪 Testes Realizados
Teste de Integridade: Chaves estrangeiras funcionando

Teste de Performance: Índices otimizando consultas

Teste de Normalização: Verificação 1FN, 2FN, 3FN

Teste de Transações: COMMIT e ROLLBACK funcionais

📄 Licença
Este projeto está sob a licença MIT. Veja o arquivo LICENSE para mais detalhes.

👨‍💻 Autor
Luiz Felix da Silva Filho
