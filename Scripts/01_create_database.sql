-- Sistema de Gestão de Bibliotecas Universitárias (SGBU)
-- Para PostgreSQL (recomendado)
CREATE DATABASE biblioteca_universitaria
    WITH 
    OWNER = postgres
    ENCODING = 'UTF8'
    LC_COLLATE = 'pt_BR.UTF-8'
    LC_CTYPE = 'pt_BR.UTF-8'
    TABLESPACE = pg_default
    CONNECTION LIMIT = -1
    IS_TEMPLATE = False;

COMMENT ON DATABASE biblioteca_universitaria 
    IS 'Banco de dados do Sistema de Gestão de Bibliotecas Universitárias (SGBU)';

-- Para MySQL (opcional)
/*
CREATE DATABASE IF NOT EXISTS biblioteca_universitaria
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

USE biblioteca_universitaria;
*/