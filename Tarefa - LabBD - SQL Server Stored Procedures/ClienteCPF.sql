CREATE DATABASE ClienteCPF

USE ClienteCPF

CREATE TABLE Cliente(
	cpf VARCHAR(11),
	nome VARCHAR(100) ,
	email VARCHAR(200),
	limiteCred DECIMAL(7, 2),
	dataNasc DATE,
	PRIMARY KEY(cpf)
)

SELECT * FROM Cliente

CREATE PROCEDURE calculoCpf(@cpf VARCHAR(11), @cont AS INT, @result INT OUTPUT) AS
	DECLARE @soma INT = 0
	DECLARE @val VARCHAR(1)
	DECLARE @pos INT = 0

	WHILE (@cont >= 2) BEGIN
		SET @pos = @pos + 1
		SET @val = SUBSTRING(@cpf, @pos, 1)
		SET @soma = @soma + (CAST(@val AS INT) * @cont)
		SET @cont = @cont - 1
	END
	   SET @result = @soma % 11 

CREATE PROCEDURE validaDigitoCpf(@cpf AS VARCHAR(11), @restDiv AS INT, @pos AS INT, @saida VARCHAR(100) OUTPUT) AS
	IF (@restDiv >= 2) BEGIN
		IF (SUBSTRING(@cpf, @pos, 1) LIKE CAST(11 - @restDiv AS VARCHAR(1))) BEGIN
			SET @saida = 'v�lida'
		END ELSE BEGIN
			SET @saida = 'inv�lida'
		END
	END ELSE BEGIN
		IF (SUBSTRING(@cpf, @pos, 1) = '0') BEGIN
			SET @saida = 'v�lida'
		END ELSE BEGIN
			SET @saida = 'inv�lida'
		END
	END 

CREATE PROCEDURE validarCPF(@cpf VARCHAR(11), @valido BIT OUTPUT) AS
	DECLARE @Nr_Documento_Aux VARCHAR(11)
    SET @Nr_Documento_Aux = LTRIM(RTRIM(@cpf))

	IF (@Nr_Documento_Aux NOT IN ('00000000000', '11111111111', '22222222222', '33333333333', '44444444444', '55555555555',
	'66666666666', '77777777777', '88888888888', '99999999999', '12345678909')) BEGIN
		DECLARE @saida VARCHAR(100)
		DECLARE @restDiv INT = 0

		EXEC calculoCpf @cpf, 10, @restDiv OUTPUT
		EXEC validaDigitoCpf @cpf, @restDiv, 10, @saida OUTPUT

		IF (@saida = 'v�lida') BEGIN
			SET @restDiv = 0
	
			EXEC calculoCpf @cpf, 11, @restDiv OUTPUT
			EXEC validaDigitoCpf @cpf, @restDiv, 11, @saida OUTPUT

			IF (@saida = 'v�lida') BEGIN
				SET @valido = 1 
			END ELSE BEGIN
				SET @valido = 0
			END
			END ELSE BEGIN
				SET @valido = 0
			END
		END ELSE BEGIN 
			SET @valido = 0
	END

	CREATE PROCEDURE crudCliente(@acao AS CHAR(1), @cpf AS VARCHAR(11), 
@nome AS VARCHAR(100), @email AS VARCHAR(200), @limiteCred AS DECIMAL(7, 2), 
@dataNasc AS VARCHAR(10), @saida VARCHAR(100) OUTPUT) AS
	DECLARE @valido BIT = 1
	--EXEC validarCPF @cpf, @valido OUTPUT
	
	IF(@valido = 1) BEGIN
		IF (LOWER(@acao) = 'i') BEGIN
			INSERT INTO Cliente VALUES(@cpf, @nome, @email, @limiteCred, @dataNasc)
			SET @saida = 'Cliente cadastrado com sucesso'
		END
		IF (LOWER(@acao) = 'u') BEGIN
			UPDATE Cliente SET nome = @nome, email = @email, limiteCred = @limiteCred, dataNasc = @dataNasc WHERE cpf= @cpf
			SET @saida = 'Cliente atualizado com sucesso'
		END
		IF (LOWER(@acao) = 'r') BEGIN
			DELETE Cliente WHERE cpf = @cpf
			SET @saida = 'Cliente deletado com sucesso'
		END
	    END ELSE BEGIN
		RAISERROR('CPF inv�lido', 16, 1)
	END