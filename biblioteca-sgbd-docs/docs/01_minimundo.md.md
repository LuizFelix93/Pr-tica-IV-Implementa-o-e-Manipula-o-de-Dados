# 📚 Sistema de Gestão de Bibliotecas Universitárias (SGBU)

## 1. Visão Geral

### 1.1. Contexto
O **Sistema de Gestão de Bibliotecas Universitárias (SGBU)** é um projeto desenvolvido para automatizar e otimizar os processos de uma biblioteca universitária de médio porte, que atende aproximadamente 8.000 usuários e gerencia um acervo de 50.000 livros.

### 1.2. Problema Atual
Atualmente, a biblioteca opera com processos manuais utilizando planilhas e registros em papel, resultando em:
- Lentidão nos atendimentos
- Inconsistências nos registros
- Dificuldade no controle do acervo
- Falta de relatórios gerenciais
- Controle ineficiente de prazos e multas

### 1.3. Solução Proposta
Desenvolvimento de um sistema informatizado que permita:
- Controle centralizado do acervo
- Automatização de empréstimos e devoluções
- Gestão eficiente de usuários
- Geração de relatórios gerenciais
- Controle automático de multas

## 2. Regras de Negócio

### 2.1. Cadastro de Usuários
- **Tipos de usuários:** Alunos, Professores, Funcionários
- **Requisitos:** Cadastro prévio obrigatório
- **Validação:** Cada usuário possui código único
- **Campos obrigatórios:** Nome, Telefone, E-mail, Categoria
- **Status:** Ativo/Inativo/Suspenso

### 2.2. Gestão do Acervo
- **Identificação:** Livros identificados por ISBN
- **Exemplares:** Múltiplos exemplares físicos por livro
- **Autores:** Relacionamento N:N (um livro pode ter vários autores)
- **Editoras:** Cada livro possui uma editora principal
- **Status dos exemplares:** Disponível/Emprestado/Manutenção

### 2.3. Processos de Empréstimo
- **Prazos diferenciados:**
  - Professores: 30 dias
  - Alunos e Funcionários: 15 dias
- **Validações:**
  - Usuário deve estar ativo
  - Exemplar deve estar disponível
  - Usuário não pode ter multas pendentes
- **Renovação:** Permitida uma vez, se não houver reservas

### 2.4. Sistema de Multas
- **Cálculo:** R$ 1,50 por dia de atraso
- **Geração:** Automática após data de devolução
- **Status:** Pendente/Paga/Cancelada
- **Bloqueio:** Usuários com multas pendentes não podem fazer novos empréstimos

### 2.5. Reservas
- **Limite:** 3 reservas por usuário simultaneamente
- **Prazo:** 48 horas para retirada após notificação
- **Prioridade:** Por ordem de solicitação

## 3. Requisitos Funcionais

### 3.1. Cadastro e Manutenção
- RF001: Cadastrar novos usuários
- RF002: Atualizar dados de usuários
- RF003: Inativar/reativar usuários
- RF004: Cadastrar novos livros
- RF005: Cadastrar exemplares físicos
- RF006: Cadastrar autores e editoras

### 3.2. Operações de Empréstimo
- RF007: Registrar empréstimo de exemplar
- RF008: Registrar devolução de exemplar
- RF009: Renovar empréstimo
- RF010: Reservar exemplar
- RF011: Cancelar reserva

### 3.3. Gestão Financeira
- RF012: Gerar multa por atraso
- RF013: Registrar pagamento de multa
- RF014: Cancelar multa (justificada)
- RF015: Emitir comprovante de pagamento

### 3.4. Consultas e Relatórios
- RF016: Consultar disponibilidade de livros
- RF017: Verificar histórico de usuário
- RF018: Emitir relatório de empréstimos ativos
- RF019: Emitir relatório de multas pendentes
- RF020: Emitir estatísticas de uso

### 3.5. Controle do Acervo
- RF021: Alterar status de exemplar
- RF022: Registrar perda/danificação
- RF023: Realizar inventário
- RF024: Sugerir aquisições baseado em demanda

## 4. Requisitos Não-Funcionais

### 4.1. Desempenho
- RNF001: Tempo de resposta < 2 segundos para operações comuns
- RNF002: Suporte a 100 usuários simultâneos
- RNF003: Backup diário automático
- RNF004: Disponibilidade 24/7 (exceto manutenção)

### 4.2. Segurança
- RNF005: Autenticação por senha
- RNF006: Controle de acesso por perfil
- RNF007: Criptografia de dados sensíveis
- RNF008: Log de todas as operações

### 4.3. Usabilidade
- RNF009: Interface intuitiva em português
- RNF010: Suporte a impressão de comprovantes
- RNF011: Sistema responsivo
- RNF012: Documentação completa

### 4.4. Manutenibilidade
- RNF013: Código modular e documentado
- RNF014: Banco de dados normalizado
- RNF015: Facilidade de atualização
- RNF016: Compatibilidade com PostgreSQL/MySQL

## 5. Escopo do Sistema

### 5.1. Inclui
- Gestão de usuários (alunos, professores, funcionários)
- Controle completo do acervo bibliográfico
- Sistema de empréstimos e devoluções
- Gestão de multas e pagamentos
- Relatórios gerenciais
- Consultas online
- Backup e recuperação de dados

### 5.2. Não Inclui
- Catálogo online público
- Sistema de aquisições
- Integração com sistema financeiro da universidade
- Controle de acesso físico (catracas)
- Gestão de periódicos científicos
- Sistema de e-books

## 6. Público-Alvo

### 6.1. Usuários Diretos
- **Bibliotecários:** Administração central do sistema
- **Atendentes:** Operação no balcão de atendimento
- **Alunos:** Consultas e autoatendimento
- **Professores:** Empréstimos com prazos especiais
- **Funcionários:** Empréstimos regulares

### 6.2. Usuários Indiretos
- **Coordenação da biblioteca:** Tomada de decisão baseada em relatórios
- **TI da universidade:** Manutenção do sistema
- **Fornecedores:** Dados para aquisições

## 7. Benefícios Esperados

### 7.1. Operacionais
- Redução de 70% no tempo de atendimento
- Eliminação de erros manuais
- Controle preciso do acervo
- Automatização de processos repetitivos

### 7.2. Gerenciais
- Relatórios em tempo real
- Tomada de decisão baseada em dados
- Otimização do acervo
- Redução de perdas

### 7.3. Para Usuários
- Melhor experiência no atendimento
- Autonomia nas consultas
- Notificações automáticas
- Histórico pessoal de empréstimos

## 8. Tecnologias Utilizadas

### 8.1. Banco de Dados
- **SGBD:** PostgreSQL 14+ (ou MySQL 8+)
- **Linguagem:** SQL (DDL, DML, DQL)
- **Ferramentas:** pgAdmin, DBeaver

### 8.2. Desenvolvimento
- **Versionamento:** Git, GitHub
- **Documentação:** Markdown, Mermaid.js
- **Testes:** pgTAP (ou similar)

### 8.3. Infraestrutura
- **Servidor:** Linux/Windows Server
- **Backup:** Scripts automáticos
- **Monitoramento:** pg_stat, logs

---