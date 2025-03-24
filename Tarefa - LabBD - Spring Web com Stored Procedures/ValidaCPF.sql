-- Cria��o do banco de dados
CREATE DATABASE clientes_db;

-- Usando o banco de dados
USE clientes_db;

-- Cria��o da tabela cliente
CREATE TABLE cliente (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(255),
    cpf VARCHAR(11) UNIQUE,
    telefone VARCHAR(15),
    email VARCHAR(255)
);

--vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv

-- Fun��o para validar CPF
CREATE FUNCTION ValidaCPF (cpf VARCHAR(11)) RETURNS BOOLEAN
BEGIN
    DECLARE valid BOOLEAN DEFAULT TRUE;
    DECLARE sum INT DEFAULT 0;
    DECLARE remainder INT;
    DECLARE i INT;

    -- Verificar se todos os d�gitos s�o iguais (ex: 11111111111)
    IF cpf = REPEAT(SUBSTRING(cpf, 1, 1), 11) THEN
        SET valid = FALSE;
    ELSE
        -- Valida��o de CPF
        SET sum = 0;
        FOR i IN 1..9 DO
            SET sum = sum + (CAST(SUBSTRING(cpf, i, 1) AS INT) * (11 - i));
        END FOR;
        SET remainder = sum % 11;

        -- Valida��o do primeiro d�gito
        IF remainder < 2 THEN
            IF CAST(SUBSTRING(cpf, 10, 1) AS INT) != 0 THEN
                SET valid = FALSE;
            END IF;
        ELSE
            IF CAST(SUBSTRING(cpf, 10, 1) AS INT) != (11 - remainder) THEN
                SET valid = FALSE;
            END IF;
        END IF;

        -- Valida��o do segundo d�gito
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
    -- Verifica se o CPF � v�lido
    IF NOT ValidaCPF(p_cpf) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'CPF inv�lido';
    END IF;

    -- Verifica se o CPF n�o � uma sequ�ncia repetida
    IF p_cpf LIKE '11111111111' OR p_cpf LIKE '22222222222' OR p_cpf LIKE '33333333333' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'CPF inv�lido: sequ�ncia repetida';
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
    -- N�o pode alterar o CPF, ent�o n�o h� verifica��o do CPF aqui
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

