-- Criação do banco de dados
CREATE DATABASE clientes_db;

-- Usando o banco de dados
USE clientes_db;

-- Criação da tabela cliente
CREATE TABLE cliente (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(255),
    cpf VARCHAR(11) UNIQUE,
    telefone VARCHAR(15),
    email VARCHAR(255)
);

--vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv

-- Função para validar CPF
CREATE FUNCTION ValidaCPF (cpf VARCHAR(11)) RETURNS BOOLEAN
BEGIN
    DECLARE valid BOOLEAN DEFAULT TRUE;
    DECLARE sum INT DEFAULT 0;
    DECLARE remainder INT;
    DECLARE i INT;

    -- Verificar se todos os dígitos são iguais (ex: 11111111111)
    IF cpf = REPEAT(SUBSTRING(cpf, 1, 1), 11) THEN
        SET valid = FALSE;
    ELSE
        -- Validação de CPF
        SET sum = 0;
        FOR i IN 1..9 DO
            SET sum = sum + (CAST(SUBSTRING(cpf, i, 1) AS INT) * (11 - i));
        END FOR;
        SET remainder = sum % 11;

        -- Validação do primeiro dígito
        IF remainder < 2 THEN
            IF CAST(SUBSTRING(cpf, 10, 1) AS INT) != 0 THEN
                SET valid = FALSE;
            END IF;
        ELSE
            IF CAST(SUBSTRING(cpf, 10, 1) AS INT) != (11 - remainder) THEN
                SET valid = FALSE;
            END IF;
        END IF;

        -- Validação do segundo dígito
        SET sum = 0;
        FOR i IN 1..10 DO
            SET sum = sum + (CAST(SUBSTRING(cpf, i, 1) AS INT) * (12 - i));
        END FOR;
        SET remainder = sum % 11;

        IF remainder < 2 THEN
            IF CAST(SUBSTRING(cpf, 11, 1) AS INT) != 0 THEN
                SET valid = FALSE;
            END IF;
        ELSE
            IF CAST(SUBSTRING(cpf, 11, 1) AS INT) != (11 - remainder) THEN
                SET valid = FALSE;
            END IF;
        END IF;
    END IF;

    RETURN valid;
END;

--vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv

-- Procedure para inserir cliente
CREATE PROCEDURE InsertCliente(
    IN p_nome VARCHAR(255),
    IN p_cpf VARCHAR(11),
    IN p_telefone VARCHAR(15),
    IN p_email VARCHAR(255)
)
BEGIN
    -- Verifica se o CPF é válido
    IF NOT ValidaCPF(p_cpf) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'CPF inválido';
    END IF;

    -- Verifica se o CPF não é uma sequência repetida
    IF p_cpf LIKE '11111111111' OR p_cpf LIKE '22222222222' OR p_cpf LIKE '33333333333' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'CPF inválido: sequência repetida';
    END IF;

    -- Realiza o insert no banco
    INSERT INTO cliente (nome, cpf, telefone, email)
    VALUES (p_nome, p_cpf, p_telefone, p_email);
END;

-- Procedure para atualizar cliente
CREATE PROCEDURE UpdateCliente(
    IN p_id INT,
    IN p_nome VARCHAR(255),
    IN p_telefone VARCHAR(15),
    IN p_email VARCHAR(255)
)
BEGIN
    -- Não pode alterar o CPF, então não há verificação do CPF aqui
    UPDATE cliente
    SET nome = p_nome, telefone = p_telefone, email = p_email
    WHERE id = p_id;
END;

-- Procedure para excluir cliente
CREATE PROCEDURE DeleteCliente(IN p_id INT)
BEGIN
    DELETE FROM cliente WHERE id = p_id;
END;

--vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv

