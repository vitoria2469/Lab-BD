CREATE DATABASE mercadinho

USE mercadinho

CREATE TABLE Produto (
    Codigo INT PRIMARY KEY,
    Nome NVARCHAR(100) NOT NULL,
    Valor DECIMAL(10, 2) NOT NULL
)

CREATE TABLE ENTRADA (
    Codigo_Transacao INT PRIMARY KEY,
    Codigo_Produto INT NOT NULL,
    Quantidade INT NOT NULL,
    Valor_Total DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (Codigo_Produto) REFERENCES Produto(Codigo)
)

CREATE TABLE SAIDA (
    Codigo_Transacao INT PRIMARY KEY,
    Codigo_Produto INT NOT NULL,
    Quantidade INT NOT NULL,
    Valor_Total DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (Codigo_Produto) REFERENCES Produto(Codigo)
)
GO

SELECT * FROM Produto
SELECT * FROM ENTRADA
SELECT * FROM SAIDA

INSERT INTO Produto (Codigo, Nome, Valor) VALUES (101, 'Celular', 2000.00);
INSERT INTO Produto (Codigo, Nome, Valor) VALUES (102, 'Bolsa', 200.00);
INSERT INTO Produto (Codigo, Nome, Valor) VALUES (103, 'Nintendo 3DS', 900.00);
INSERT INTO Produto (Codigo, Nome, Valor) VALUES (104, 'Computador', 10000.00);
INSERT INTO Produto (Codigo, Nome, Valor) VALUES (105, 'PlayStation', 3500.00);
INSERT INTO Produto (Codigo, Nome, Valor) VALUES (106, 'Garrafa', 70.00);


CREATE PROCEDURE InserirTransacao
    @Tipo CHAR(1), -- 'e' para ENTRADA, 's' para SAIDA
    @Codigo_Transacao INT,
    @Codigo_Produto INT,
    @Quantidade INT
AS
BEGIN
    DECLARE @Valor DECIMAL(10, 2);
    DECLARE @Valor_Total DECIMAL(10, 2);

    IF @Tipo NOT IN ('e', 's')
    BEGIN
        RAISERROR('Codigo invalido. Use ''e'' para ENTRADA ou ''s'' para SAIDA.', 16, 1);
        RETURN
    END

    SELECT @Valor = Valor
    FROM Produto
    WHERE Codigo = @Codigo_Produto;

    IF @Valor IS NULL
    BEGIN
        RAISERROR('Produto nao encontrado.', 16, 1);
        RETURN
    END

    SET @Valor_Total = @Valor * @Quantidade;

    IF @Tipo = 'e'
    BEGIN
        INSERT INTO ENTRADA (Codigo_Transacao, Codigo_Produto, Quantidade, Valor_Total)
        VALUES (@Codigo_Transacao, @Codigo_Produto, @Quantidade, @Valor_Total);
    END
    ELSE IF @Tipo = 's'
    BEGIN
        INSERT INTO SAIDA (Codigo_Transacao, Codigo_Produto, Quantidade, Valor_Total)
        VALUES (@Codigo_Transacao, @Codigo_Produto, @Quantidade, @Valor_Total);
    END
END


EXEC InserirTransacao 'e', 2, 102, 3;
EXEC InserirTransacao 'e', 1, 106, 4;
EXEC InserirTransacao 's', 2, 102, 2;
EXEC InserirTransacao 's', 1, 106, 3;


SELECT * FROM ENTRADA;
SELECT * FROM SAIDA;