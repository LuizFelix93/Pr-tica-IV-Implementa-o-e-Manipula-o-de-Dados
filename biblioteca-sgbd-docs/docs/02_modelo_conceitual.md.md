# 🎯 Modelo Conceitual - DER

## 1. Objetivo do Modelo Conceitual

O modelo conceitual representa a **visão de alto nível** do sistema, identificando as principais entidades, seus atributos e relacionamentos, sem se preocupar com detalhes de implementação.

## 2. Entidades Identificadas

### 2.1. USUÁRIO
Representa todas as pessoas que podem utilizar os serviços da biblioteca.

**Atributos:**
- `codigo_usuario` (PK): Identificador único
- `nome`: Nome completo
- `telefone`: Número de contato
- `email`: Endereço eletrônico
- `categoria`: Aluno/Professor/Funcionário
- `data_cadastro`: Data do cadastro
- `status`: Ativo/Inativo/Suspenso

### 2.2. LIVRO
Representa a informação bibliográfica de um título.

**Atributos:**
- `isbn` (PK): Código ISBN (13 dígitos)
- `titulo`: Título completo
- `ano_publicacao`: Ano de publicação
- `edicao`: Número da edição
- `paginas`: Quantidade de páginas
- `genero`: Gênero literário

### 2.3. AUTOR
Representa os escritores dos livros.

**Atributos:**
- `codigo_autor` (PK): Identificador único
- `nome`: Nome completo
- `nacionalidade`: Nacionalidade
- `data_nascimento`: Data de nascimento
- `biografia`: Biografia resumida

### 2.4. EDITORA
Representa as empresas publicadoras.

**Atributos:**
- `codigo_editora` (PK): Identificador único
- `nome`: Razão social
- `site`: Site oficial
- `pais`: País de origem

### 2.5. EXEMPLAR
Representa cada cópia física de um livro.

**Atributos:**
- `codigo_exemplar` (PK): Identificador único
- `data_aquisicao`: Data de entrada no acervo
- `status`: Disponível/Emprestado/Manutenção
- `localizacao`: Localização física
- `observacoes`: Anotações sobre o exemplar

### 2.6. EMPRÉSTIMO
Representa cada operação de retirada.

**Atributos:**
- `codigo_emprestimo` (PK): Identificador único
- `data_retirada`: Data do empréstimo
- `data_devolucao_prevista`: Data prevista para devolução
- `data_devolucao_real`: Data real da devolução
- `status`: Ativo/Devolvido/Atrasado

### 2.7. MULTA
Representa penalidades por atraso.

**Atributos:**
- `codigo_multa` (PK): Identificador único
- `valor`: Valor monetário
- `data_geracao`: Data de criação
- `data_pagamento`: Data do pagamento
- `status`: Pendente/Paga/Cancelada
- `motivo`: Descrição do motivo

## 3. Relacionamentos

### 3.1. USUÁRIO ↔ EMPRÉSTIMO
- **Tipo:** 1:N
- **Descrição:** Um usuário pode fazer vários empréstimos, mas cada empréstimo pertence a um único usuário
- **Cardinalidade:** (1,1) - (0,N)

### 3.2. LIVRO ↔ EXEMPLAR
- **Tipo:** 1:N
- **Descrição:** Um livro pode ter vários exemplares físicos, mas cada exemplar corresponde a um único livro
- **Cardinalidade:** (1,1) - (1,N)

### 3.3. EXEMPLAR ↔ EMPRÉSTIMO
- **Tipo:** 1:N
- **Descrição:** Um exemplar pode ser emprestado várias vezes ao longo do tempo, mas cada empréstimo refere-se a um único exemplar
- **Cardinalidade:** (1,1) - (0,N)

### 3.4. EMPRÉSTIMO ↔ MULTA
- **Tipo:** 1:1
- **Descrição:** Cada empréstimo em atraso pode gerar uma multa, e cada multa está associada a um único empréstimo
- **Cardinalidade:** (0,1) - (0,1)

### 3.5. LIVRO ↔ AUTOR
- **Tipo:** N:M
- **Descrição:** Um livro pode ter vários autores, e um autor pode escrever vários livros
- **Resolução:** Tabela associativa ESCREVE
- **Cardinalidade:** (1,N) - (1,N)

### 3.6. LIVRO ↔ EDITORA
- **Tipo:** N:1
- **Descrição:** Vários livros podem ser publicados pela mesma editora, mas cada livro tem uma única editora principal
- **Cardinalidade:** (N,1) - (1,1)

## 4. Diagrama Conceitual (Notação Chen)
┌─────────────────┐ ┌─────────────────┐
│ USUÁRIO │ │ LIVRO │
├─────────────────┤ ├─────────────────┤
│ codigo (PK) │ │ isbn (PK) │
│ nome │ │ titulo │
│ telefone │ │ ano_publicacao │
│ email │ │ edicao │
│ categoria │ │ paginas │
│ data_cadastro │ │ genero │
│ status │ └─────────────────┘
└─────────────────┘ │
│ │ ┌─────────────────┐
│ │ │ AUTOR │
│ (1,N) │ (1,N) ├─────────────────┤
│ ├─────── │ codigo (PK) │
┌─────────────────┐ ┌─────────────────┐ nome │
│ EMPRÉSTIMO │ │ EXEMPLAR │ nacionalidade │
├─────────────────┤ ├─────────────────┤ data_nascimento │
│ codigo (PK) │ │ codigo (PK) │ biografia │
│ data_retirada │ │ data_aquisicao └─────────────────┘
│ data_devol_prev │ │ status │
│ data_devol_real │ │ localizacao │ │
│ status │ │ observacoes │ │
└─────────────────┘ └─────────────────┘ │ (N,M)
│ │ │
│ (0,1) │ (1,1) │
│ │ │
┌─────────────────┐ ┌─────────────────┐ │
│ MULTA │ │ EDITORA │ │
├─────────────────┤ ├─────────────────┤ │
│ codigo (PK) │ │ codigo (PK) │ │
│ valor │ │ nome │ │
│ data_geracao │ │ site │ │
│ data_pagamento │ │ pais │ │
│ status │ └─────────────────┘ │
│ motivo │ │ │
└─────────────────┘ │ (N,1) │
│ │
│ ┌─────────────────┐
│ │ ESCREVE │
│ ├─────────────────┤
└─────────│ isbn (FK) │
│ codigo_autor(FK)│
└─────────────────┘
## 5. Regras de Negócio no Modelo Conceitual

### 5.1. Restrições de Domínio
- `categoria_usuario` ∈ {Aluno, Professor, Funcionário}
- `status_exemplar` ∈ {Disponível, Emprestado, Manutenção}
- `status_emprestimo` ∈ {Ativo, Devolvido, Atrasado}
- `status_multa` ∈ {Pendente, Paga, Cancelada}

### 5.2. Restrições de Integridade
- Um usuário inativo não pode fazer novos empréstimos
- Um exemplar em manutenção não pode ser emprestado
- A data de devolução prevista deve ser posterior à data de retirada
- O valor da multa deve ser maior ou igual a zero

### 5.3. Regras de Negócio Específicas
- **Prazos diferenciados:** Professores (30 dias), outros (15 dias)
- **Limite de empréstimos:** 5 livros por usuário simultaneamente
- **Bloqueio por multa:** Usuários com multas pendentes bloqueados
- **Renovação:** Permitida apenas uma vez por empréstimo

## 6. Pressupostos do Modelo

### 6.1. Pressupostos de Design
- Cada exemplar físico é único e identificável
- Um livro pode não ter exemplares físicos (apenas registro bibliográfico)
- Um autor pode existir sem livros cadastrados
- Uma editora pode existir sem livros publicados

### 6.2. Pressupostos Operacionais
- Todos os empréstimos são presenciais
- As devoluções são sempre presenciais
- As multas são pagas em dinheiro no balcão
- Não há sistema de reservas online

### 6.3. Pressupostos de Negócio
- Não há empréstimos entre bibliotecas
- Não há sistema de sugestão de compras
- Não há controle de frequência dos usuários
- Não há sistema de avaliação dos livros

## 7. Glossário de Termos

| Termo | Definição |
|-------|-----------|
| **Exemplar** | Cópia física individual de um livro |
| **ISBN** | International Standard Book Number (13 dígitos) |
| **Empréstimo** | Operação de retirada temporária de exemplar |
| **Multa** | Penalidade financeira por atraso na devolução |
| **Acervo** | Conjunto total de livros da biblioteca |
| **Usuário ativo** | Usuário com cadastro válido e sem restrições |
| **Exemplar disponível** | Exemplar que pode ser emprestado imediatamente |

## 8. Evolução do Modelo

### 8.1. Versão 1.0 (Atual)
- Estrutura básica de gestão bibliotecária
- Foco em empréstimos físicos
- Controle manual de multas

### 8.2. Próximas Versões (Planejadas)
- **v2.0:** Sistema de reservas online
- **v3.0:** Integração com catálogo digital
- **v4.0:** Sistema de aquisições automatizado
