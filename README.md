📚 SGBU - Sistema de Gestão de Bibliotecas Universitárias

📋 Sobre o Projeto

Sistema completo para gerenciamento de bibliotecas universitárias, implementado com banco de dados relacional (PostgreSQL/MySQL) seguindo as melhores práticas de modelagem de dados.

🏗️ Modelagem do Banco
Modelo Entidade-Relacionamento completo

Normalização até 3FN (Terceira Forma Normal)

8 tabelas principais com relacionamentos otimizados

Índices e constraints para performance e integridade

🛠️ Tecnologias
PostgreSQL 14+ ou MySQL 8+

SQL puro (DDL, DML, DQL)

Git para controle de versão

Mermaid.js para diagramas

📁 Estrutura do Projeto
text
SGBU/
├── database/
│   ├── schema.sql        # Criação do schema
│   ├── inserts.sql       # Dados iniciais
│   ├── queries.sql       # Consultas SQL
│   └── procedures.sql    # Procedures e funções
├── docs/
│   └── DER.md           # Diagramas
└── README.md
🚀 Configuração Rápida
bash
# Clone o repositório
git clone https://github.com/seu-usuario/SGBU.git
cd SGBU
# Execute os scripts SQL
psql -U seu_usuario -d sgbiblioteca -f database/schema.sql
psql -U seu_usuario -d sgbiblioteca -f database/inserts.sql
🔍 Funcionalidades Principais
✅ Cadastro completo de livros, autores, editoras

✅ Gestão de usuários (alunos, professores, funcionários)

✅ Sistema de empréstimos com controle de prazos

✅ Reservas online de livros

✅ Cálculo automático de multas por atraso

✅ Relatórios estatísticos do acervo

📄 Licença
Distribuído sob licença MIT. Veja LICENSE para mais informações.

Desenvolvido por Luiz Felix Da SIlva Filho • 📧 zinho.felix00@gmail.com • 🔗 https://www.linkedin.com/in/luiz-felix0
