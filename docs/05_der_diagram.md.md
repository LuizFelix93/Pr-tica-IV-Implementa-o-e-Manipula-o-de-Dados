\## 1. Visão Geral do Diagrama

O Diagrama Entidade-Relacionamento (DER) apresenta a \*\*estrutura completa\*\* do banco de dados do Sistema de Gestão de Bibliotecas Universitárias, mostrando todas as entidades, atributos, relacionamentos e cardinalidades.

\## 2. Diagrama em Notação Crow's Foot

\### 2.1. Diagrama Completo

\```mermaid

erDiagram

USUARIO {

int codigo\_usuario PK

varchar nome

varchar telefone

varchar email

varchar categoria

date data\_cadastro

varchar status

}

LIVRO {

varchar isbn PK

varchar titulo

int ano\_publicacao

int codigo\_editora FK

int edicao

int paginas

varchar genero

}

AUTOR {

int codigo\_autor PK

varchar nome

varchar nacionalidade

date data\_nascimento

text biografia

}

EXEMPLAR {

int codigo\_exemplar PK

varchar isbn FK

date data\_aquisicao

varchar status

varchar localizacao

text observacoes

}

EMPRESTIMO {

int codigo\_emprestimo PK

int codigo\_usuario FK

int codigo\_exemplar FK

date data\_retirada

date data\_devolucao\_prevista

date data\_devolucao\_real

varchar status

}

MULTA {

int codigo\_multa PK

int codigo\_emprestimo FK

decimal valor

date data\_geracao

date data\_pagamento

varchar status

varchar motivo

}

EDITORA {

int codigo\_editora PK

varchar nome

varchar site

varchar pais

}

ESCREVE {

varchar isbn FK

int codigo\_autor FK

}

USUARIO ||--o{ EMPRESTIMO : "realiza"

LIVRO ||--o{ EXEMPLAR : "possui"

EXEMPLAR ||--o{ EMPRESTIMO : "é emprestado em"

EMPRESTIMO ||--|| MULTA : "gera"

LIVRO ||--o{ ESCREVE : "escrito por"

AUTOR ||--o{ ESCREVE : "escreve"

LIVRO }|--|| EDITORA : "publicado por"

####2.2. Diagrama Textual Alternativo

┌──────────────┐        ┌──────────────┐        ┌──────────────┐

│   USUÁRIO    │        │    LIVRO     │        │    AUTOR     │

│──────────────│        │──────────────│        │──────────────│

│ codigo(PK)   │        │ isbn(PK)     │        │ codigo(PK)   │

│ nome         │        │ titulo       │        │ nome         │

│ telefone     │        │ ano\_public   │        │ nacionalidade│

│ email        │        │ cod\_editora  │        │ dt\_nascimento│

│ categoria    │        │ edicao       │        │ biografia    │

│ dt\_cadastro  │        │ paginas      │        └──────────────┘

│ status       │        │ genero       │               │

└──────────────┘        └──────────────┘               │

│                        │                       │

│ (1)                   (1)                     (1)

│                        │                       │

│                ┌──────────────┐         ┌──────────────┐

│                │  EXEMPLAR    │         │   ESCREVE    │

│                │──────────────│         │──────────────│

│ (N)            │ codigo(PK)   │   (N)   │ isbn(FK)     │   (N)

├─────────────── │ isbn(FK)     │ ─────── │ cod\_autor(FK)│ ──────┐

│                │ dt\_aquisicao │         └──────────────┘       │

│                │ status       │                                │

│                │ localizacao  │         ┌──────────────┐       │

│                │ observacoes  │         │  EDITORA     │       │

│                └──────────────┘         │──────────────│       │

│                        │           (N)  │ codigo(PK)   │       │

│                       (1)        ────── │ nome         │       │

│                        │                │ site         │       │

│                ┌──────────────┐         │ pais         │       │

│                │ EMPRÉSTIMO   │         └──────────────┘       │

│                │──────────────│                                │

│                │ codigo(PK)   │                                │

│                │ cod\_usuario  │                                │

│                │ cod\_exemplar │                                │

│                │ dt\_retirada  │                                │

│                │ dt\_devol\_prev│                                │

│                │ dt\_devol\_real│                                │

│                │ status       │                                │

│                └──────────────┘                                │

│                        │                                       │

│                       (1)                                      │

│                        │                                       │

│                ┌──────────────┐                                │

│                │    MULTA     │                                │

│                │──────────────│                                │

│                │ codigo(PK)   │                                │

│                │ cod\_emprest  │                                │

│                │ valor        │                                │

│                │ dt\_geracao   │                                │

│                │ dt\_pagamento │                                │

│                │ status       │                                │

│                │ motivo       │                                │

│                └──────────────┘                                │

│                                                                │

└────────────────────────────────────────────────────────────────┘

##3. Legenda e Convenções

####3.1. Símbolos Utilizados

┌──────────────┐   Entidade/Table

│    NOME      │

│──────────────│

│ atributo(PK) │   Atributo com Chave Primária

│ atributo(FK) │   Atributo com Chave Estrangeira

│ atributo     │   Atributo comum

└──────────────┘

Relacionamentos:

│───│   Um para Um (1:1)

│───{   Um para Muitos (1:N)

}───{   Muitos para Muitos (N:M)

Cardinalidades:

(1)    Um (obrigatório)

(0,1)  Zero ou Um

(1,N)  Um ou Muitos

(0,N)  Zero ou Muitos

(N)    Muitos

####3.2. Cores e Estilos

Azul: Entidades principais (USUARIO, LIVRO)

Verde: Entidades de suporte (AUTOR, EDITORA)

Laranja: Entidades transacionais (EMPRÉSTIMO, MULTA)

Cinza: Entidades associativas (ESCREVE)

Linha sólida: Relacionamento obrigatório

Linha tracejada: Relacionamento opcional

##4. Descrição Detalhada dos Relacionamentos

####4.1. USUÁRIO → EMPRÉSTIMO

Tipo: 1:N

Cardinalidade: (1,1) - (0,N)

Descrição: Um usuário pode realizar zero ou muitos empréstimos, mas cada empréstimo pertence a exatamente um usuário

Restrições: Usuário deve estar ativo, sem multas pendentes

####4.2. LIVRO → EXEMPLAR

Tipo: 1:N

Cardinalidade: (1,1) - (1,N)

Descrição: Um livro deve ter pelo menos um exemplar físico, e pode ter muitos. Cada exemplar corresponde a um único livro

Restrições: ISBN deve ser válido

####4.3. EXEMPLAR → EMPRÉSTIMO

Tipo: 1:N

Cardinalidade: (1,1) - (0,N)

Descrição: Um exemplar pode ser emprestado zero ou muitas vezes ao longo do tempo. Cada empréstimo refere-se a um único exemplar

Restrições: Exemplar deve estar disponível

####4.4. EMPRÉSTIMO → MULTA

Tipo: 1:1

Cardinalidade: (0,1) - (0,1)

Descrição: Um empréstimo pode gerar no máximo uma multa (se houver atraso). Cada multa está associada a um único empréstimo

Restrições: Multa só é gerada se houver atraso na devolução

####4.5. LIVRO ↔ AUTOR (via ESCREVE)

Tipo: N:M

Cardinalidade: (1,N) - (1,N)

Descrição: Um livro pode ter um ou mais autores. Um autor pode escrever um ou mais livros

Resolução: Tabela associativa ESCREVE

Restrições: Livro deve ter pelo menos um autor

#####4.6. LIVRO → EDITORA

Tipo: N:1

Cardinalidade: (N,1) - (1,1)

Descrição: Muitos livros podem ser publicados por uma editora. Cada livro tem exatamente uma editora principal

Restrições: Editora deve estar cadastrada

##5. Atributos Chave por Entidade

####5.1. Chaves Primárias

Entidade	Chave Primária			Tipo			Justificativa

USUÁRIO		codigo\_usuario			SERIAL			Surrogate key, auto-incremental

LIVRO		isbn				VARCHAR(13)		Natural key, identificador único internacional

AUTOR		codigo\_autor			SERIAL			Surrogate key, auto-incremental

EDITORA		codigo\_editora			SERIAL			Surrogate key, auto-incremental

EXEMPLAR	codigo\_exemplar			SERIAL			Surrogate key, cada cópia física única

EMPRÉSTIMO	codigo\_emprestimo		SERIAL			Surrogate key, auto-incremental

MULTA		codigo\_multa			SERIAL			Surrogate key, auto-incremental

ESCREVE		(isbn, codigo\_autor)		COMPOSTA		Chave natural do relacionamento

####5.2. Chaves Estrangeiras


Entidade	Chave Estrangeira		Referência			Ação DELETE

LIVRO		codigo\_editora			EDITORA(codigo\_editora)		SET NULL

EXEMPLAR	isbn				LIVRO(isbn)			CASCADE

EMPRÉSTIMO	codigo\_usuario			USUARIO(codigo\_usuario)		RESTRICT

EMPRÉSTIMO	codigo\_exemplar			EXEMPLAR(codigo\_exemplar)	RESTRICT

MULTA		codigo\_emprestimo		EMPRÉSTIMO(codigo\_emprestimo)	CASCADE

ESCREVE		isbn				LIVRO(isbn)			CASCADE

ESCREVE		codigo\_autor			AUTOR(codigo\_autor)		CASCADE

##6. Constraints e Validações

####6.1. Constraints de Domínio

-- USUARIO.categoria

CHECK (categoria IN ('Aluno', 'Professor', 'Funcionário'))

-- USUARIO.status

CHECK (status IN ('Ativo', 'Inativo', 'Suspenso'))

-- EXEMPLAR.status

CHECK (status IN ('Disponível', 'Emprestado', 'Manutenção', 'Reservado'))

-- EMPRÉSTIMO.status

CHECK (status IN ('Ativo', 'Devolvido', 'Atrasado'))

-- MULTA.status

CHECK (status IN ('Pendente', 'Paga', 'Cancelada'))

####6.2. Constraints de Integridade

-- LIVRO.ano\_publicacao

CHECK (ano\_publicacao > 0 AND ano\_publicacao <= EXTRACT(YEAR FROM CURRENT\_DATE))

-- LIVRO.edicao

CHECK (edicao > 0)

-- LIVRO.paginas

CHECK (paginas > 0)

-- MULTA.valor

CHECK (valor >= 0)

-- EMPRÉSTIMO datas

CHECK (data\_retirada <= data\_devolucao\_prevista)

CHECK (data\_devolucao\_real IS NULL OR data\_retirada <= data\_devolucao\_real)

##7. Mapeamento para Modelo Físico

####7.1. Tabelas Resultantes

Entidade		Tabela Física		Observações

USUÁRIO			usuario			Singular em inglês

LIVRO			livro			Mantido em português

AUTOR			autor			Mantido em português

EDITORA			editora			Mantido em português

EXEMPLAR		exemplar		Mantido em português

EMPRÉSTIMO		emprestimo		Mantido em português

MULTA			multa			Mantido em português

ESCREVE			escreve			Mantido em português

####7.2. Índices Criados

-- Índices por chave estrangeira

CREATE INDEX idx\_livro\_editora ON livro(codigo\_editora);

CREATE INDEX idx\_exemplar\_isbn ON exemplar(isbn);

CREATE INDEX idx\_emprestimo\_usuario ON emprestimo(codigo\_usuario);

CREATE INDEX idx\_emprestimo\_exemplar ON emprestimo(codigo\_exemplar);

-- Índices por consultas frequentes

CREATE INDEX idx\_exemplar\_status ON exemplar(status);

CREATE INDEX idx\_emprestimo\_status ON emprestimo(status);

CREATE INDEX idx\_usuario\_email ON usuario(email);

CREATE INDEX idx\_usuario\_categoria ON usuario(categoria);

##8. Considerações de Performance

####8.1. Volumes Esperados

Tabela		Registros Iniciais	Crescimento Anual	Índices

USUARIO		8.000			1.000			3

LIVRO		50.000			5.000			2

EXEMPLAR	60.000			6.000			3

EMPRÉSTIMO	0			200.000			4

MULTA		0			5.000			2

####8.2. Consultas Críticas Otimizadas

Disponibilidade de exemplar: Índice em exemplar.status

Histórico de usuário: Índice em emprestimo.codigo\_usuario

Busca por livro: Índice trigram em livro.titulo

Empréstimos atrasados: Índice composto em emprestimo(status, data\_devolucao\_prevista)

##9. Evolução do Diagrama

####9.1. Versão 1.0 (Atual)

Estrutura básica de 8 tabelas

Relacionamentos essenciais

Cardinalidades definidas

####9.2. Próximas Versões (Roadmap)

v1.1: Adicionar tabela RESERVA

v1.2: Adicionar tabela CATEGORIA (hierarquia de gêneros)

v1.3: Adicionar tabela AVALIACAO

v2.0: Suporte a periódicos científicos

####9.3. Manutenção do DER

Revisão semestral do diagrama

Atualização conforme novas regras de negócio

Documentação de mudanças no histórico

##10. Ferramentas de Visualização

####10.1. Ferramentas Recomendadas

1. dbdiagram.io: Diagramas online, exporta SQL

1. Draw.io: Gratuito, integração com Google Drive

1. Lucidchart: Colaborativo, templates pré-definidos

1. pgModeler: Específico para PostgreSQL

####10.2. Exportação do Diagrama

-- Exportar diagrama para diferentes formatos

-- Mermaid.js (usado neste documento)

-- PNG/SVG (para documentação)

-- PDF (para impressão)

-- SQL (para implementação)
