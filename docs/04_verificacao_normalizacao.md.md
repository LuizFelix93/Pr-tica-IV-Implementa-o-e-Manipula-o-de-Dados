## 1. Introdução à Normalização

A normalização é o processo de organização dos dados em um banco de dados relacional para:

- Eliminar redundância de dados
- Garantir dependências de dados apropriadas
- Reduzir anomalias de inserção, atualização e exclusão

## 2. Primeira Forma Normal (1FN)

### 2.1. Regras da 1FN

1. Cada célula contém apenas um valor atômico
1. Não há grupos de colunas repetidas
1. Valores em uma mesma coluna são do mesmo tipo
1. Cada linha é única (identificada por uma chave primária)

### 2.2. Verificação por Tabela

#### **Tabela: USUARIO**

CREATE TABLE USUARIO (

codigo_usuario SERIAL PRIMARY KEY,  -- ✓ PK única

nome VARCHAR(100) NOT NULL,         -- ✓ Valor atômico

telefone VARCHAR(15),               -- ✓ Valor atômico

email VARCHAR(100) UNIQUE NOT NULL, -- ✓ Valor atômico

categoria VARCHAR(20) NOT NULL,     -- ✓ Valor atômico

data_cadastro DATE DEFAULT CURRENT_DATE, -- ✓ Valor atômico

status VARCHAR(10) DEFAULT 'Ativo'  -- ✓ Valor atômico

);

####**Tabela: LIVRO**

CREATE TABLE LIVRO (

isbn VARCHAR(13) PRIMARY KEY,       -- ✓ PK única

titulo VARCHAR(200) NOT NULL,       -- ✓ Valor atômico

ano_publicacao INTEGER,             -- ✓ Valor atômico

codigo_editora INTEGER,             -- ✓ Valor atômico (FK)

edicao INTEGER,                     -- ✓ Valor atômico

paginas INTEGER,                    -- ✓ Valor atômico

genero VARCHAR(50)                  -- ✓ Valor atômico

);

####**Tabela: EXEMPLAR**

CREATE TABLE EXEMPLAR (

codigo_exemplar SERIAL PRIMARY KEY, -- ✓ PK única

isbn VARCHAR(13),                   -- ✓ Valor atômico (FK)

data_aquisicao DATE,                -- ✓ Valor atômico

status VARCHAR(15),                 -- ✓ Valor atômico

localizacao VARCHAR(50),            -- ✓ Valor atômico

observacoes TEXT                    -- ✓ Valor atômico

);

###2.3. Problemas Identificados e Soluções

Problema Potencial: Atributo observacoes poderia conter múltiplos valores

Solução: Mantido como TEXT único, pois é campo livre de anotações

Problema Potencial: telefone poderia armazenar múltiplos números

Solução: Definido como único valor, normalizado em campo único

###3. Segunda Forma Normal (2FN)

####3.1. Regras da 2FN

A tabela deve estar na 1FN

Todos os atributos não-chave dependem TOTALMENTE da chave primária

Não existem dependências parciais

####3.2. Análise de Dependências Parciais

Tabelas com PK Simples (7 tabelas)

EDITORA, USUARIO, AUTOR, EXEMPLAR, EMPRESTIMO, MULTA

Status: ✅ Automaticamente em 2FN (não podem ter dependências parciais)

Tabela com PK Composta: ESCREVE

CREATE TABLE ESCREVE (

isbn VARCHAR(13),           -- Parte da PK

codigo_autor INTEGER,       -- Parte da PK

data_cadastro TIMESTAMP,    -- Atributo não-chave

PRIMARY KEY (isbn, codigo_autor)

);

####3.3. Exemplos que Violariam 2FN (Não Aplicáveis)

Exemplo Violação (se existisse):

-- Tabela hipotética violando 2FN

CREATE TABLE LIVRO_AUTOR (

isbn VARCHAR(13),

codigo_autor INTEGER,

nome_autor VARCHAR(100),  -- ⚠️ Depende apenas de codigo_autor (parcial)

titulo_livro VARCHAR(200), -- ⚠️ Depende apenas de isbn (parcial)

PRIMARY KEY (isbn, codigo_autor)

);

###4. Terceira Forma Normal (3FN)

####4.1. Regras da 3FN

A tabela deve estar na 2FN

Nenhum atributo não-chave depende transitivamente de outro atributo não-chave

Todos dependem diretamente da chave primária

###4.2. Análise de Dependências Transitivas

####Tabela: USUARIO

Atributos não-chave: nome, telefone, email, categoria, data_cadastro, status

Análise:

Todos dependem diretamente de codigo_usuario

Nenhuma dependência entre atributos não-chave

Status: ✅ ATENDE 3FN

####Tabela: LIVRO

Atributos não-chave: titulo, ano_publicacao, codigo_editora, edicao, paginas, genero

Análise:

Todos dependem diretamente de isbn

codigo_editora é FK, não cria dependência transitiva

Status: ✅ ATENDE 3FN

####Tabela: EMPRESTIMO

Atributos não-chave: codigo_usuario, codigo_exemplar, data_retirada, data_devolucao_prevista, data_devolucao_real, status

Análise:

Todos dependem diretamente de codigo_emprestimo

FKs não criam dependências transitivas

Status: ✅ ATENDE 3FN

####4.3. Exemplo que Violaria 3FN (Não Aplicável)

Exemplo Violação (se existisse):

-- Tabela hipotética violando 3FN

CREATE TABLE EMPRESTIMO_DETALHADO (

codigo_emprestimo SERIAL PRIMARY KEY,

codigo_usuario INTEGER,

nome_usuario VARCHAR(100),      -- ⚠️ Depende de codigo_usuario (transitiva)

categoria_usuario VARCHAR(20),  -- ⚠️ Depende de codigo_usuario (transitiva)

data_retirada DATE

);

###5. Forma Normal de Boyce-Codd (BCNF)

####5.1. Consideração sobre BCNF

BCNF é uma versão mais forte da 3FN, onde:

Para toda dependência funcional X → Y, X deve ser uma superchave

####5.2. Análise BCNF do Modelo

Todas as tabelas atendem BCNF porque:

Todas as dependências funcionais têm determinante que é chave candidata

Não há dependências funcionais não-triviais com determinante não-chave

Exemplo de conformidade:

Em USUARIO: codigo_usuario → todos_atributos (determinante é PK)

Em LIVRO: isbn → todos_atributos (determinante é PK)

Em ESCREVE: (isbn, codigo_autor) → data_cadastro (determinante é PK composta)

###6. Formas Normais Superiores

####6.1. Quarta Forma Normal (4FN)

Eliminar dependências multivaloradas não triviais

Análise do Modelo:

Nenhuma tabela possui dependências multivaloradas

Relacionamento N:M resolvido com tabela associativa ESCREVE

Status: ✅ Atende 4FN

####6.2. Quinta Forma Normal (5FN)

Eliminar dependências de junção

Análise do Modelo:

Todas as junções são sem perdas

Não há dependências de junção não triviais

Status: ✅ Atende 5FN

####7. Tabela de Verificação Consolidada

Tabela		1FN	2FN	3FN	BCNF	4FN	5FN	Observações

EDITORA		✅	✅	✅	✅	✅	✅	PK simples

USUARIO		✅	✅	✅	✅	✅	✅	PK simples

AUTOR		✅	✅	✅	✅	✅	✅	PK simples

LIVRO		✅	✅	✅	✅	✅	✅	PK natural (ISBN)

EXEMPLAR	✅	✅	✅	✅	✅	✅	PK simples

EMPRESTIMO	✅	✅	✅	✅	✅	✅	PK simples

MULTA		✅	✅	✅	✅	✅	✅	PK simples

ESCREVE		✅	✅	✅	✅	✅	✅	PK composta

###8. Benefícios da Normalização Aplicada

####8.1. Redução de Redundância

Dados de editora não repetidos em cada livro

Dados de autor não repetidos em cada livro

Informações de usuário centralizadas

####8.2. Eliminação de Anomalias

Inserção: Pode-se cadastrar autor sem livro

Atualização: Editora atualizada uma vez só

Exclusão: Remover livro não remove autor

####8.3. Consistência de Dados

Validações por domínio (CHECK constraints)

Integridade referencial (FK constraints)

Valores padrão apropriados

####8.4. Flexibilidade

Adicionar novos atributos sem afetar estrutura

Suporte a múltiplos autores por livro

Facilidade em alterar regras de negócio

###9. Trade-offs Considerados

####9.1. Desnormalização Planejada

Exemplo: Campo data_cadastro em todas as tabelas

Motivo: Auditoria e tracking temporal

Custo: Pequena redundância aceitável

####9.2. Performance vs Normalização

Índices criados para compensar JOINs

Views materializadas para consultas complexas

Particionamento planejado para grandes tabelas

####9.3. Complexidade vs Simplicidade

Modelo balanceado entre normalização e usabilidade

Evitada normalização excessiva (6NF)

Mantida legibilidade do esquema

###10. Recomendações para Manutenção

####10.1. Monitoramento

-- Verificar violações de normalização periodicamente

SELECT * FROM pg_constraint WHERE contype = 'f';

SELECT * FROM pg_index WHERE indisunique = true;

###10.2. Evolução do Modelo

Revisar normalização após 6 meses de operação

Considerar desnormalização controlada se performance exigir

Manter documentação de decisões de design

###10.3. Backup e Recovery

Scripts de verificação inclusos no backup

Documentação de constraints para recovery

Testes regulares de integridade

###Conclusão: O modelo SGBU está completamente normalizado até a 5ª Forma Normal, garantindo estrutura robusta, sem redundâncias e preparada para escalabilidade.
