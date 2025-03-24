CREATE DATABASE mercadinho

CREATE TABLE Produto (
    Codigo INT PRIMARY KEY,          -- Código do produto (chave primária)
    Nome NVARCHAR(100) NOT NULL,    -- Nome do produto
    Valor DECIMAL(10, 2) NOT NULL    -- Valor do produto
);

CREATE TABLE ENTRADA (
    Codigo_Transacao INT PRIMARY KEY,  -- Código da transação (chave primária)
    Codigo_Produto INT NOT NULL,        -- Código do produto (chave estrangeira)
    Quantidade INT NOT NULL,            -- Quantidade do produto
    Valor_Total DECIMAL(10, 2) NOT NULL, -- Valor total da transação
    FOREIGN KEY (Codigo_Produto) REFERENCES Produto(Codigo) -- Chave estrangeira referenciando Produto
);

CREATE TABLE SAIDA (
    Codigo_Transacao INT PRIMARY KEY,  -- Código da transação (chave primária)
    Codigo_Produto INT NOT NULL,        -- Código do produto (chave estrangeira)
    Quantidade INT NOT NULL,            -- Quantidade do produto
    Valor_Total DECIMAL(10, 2) NOT NULL, -- Valor total da transação
    FOREIGN KEY (Codigo_Produto) REFERENCES Produto(Codigo) -- Chave estrangeira referenciando Produto
);


SELECT * FROM Produto
SELECT * FROM ENTRADA
SELECT * FROM SAIDA

INSERT INTO Produto (Codigo, Nome, Valor) VALUES (101, 'Produto A', 10.00);
INSERT INTO Produto (Codigo, Nome, Valor) VALUES (102, 'Produto B', 20.00);
INSERT INTO Produto (Codigo, Nome, Valor) VALUES (103, 'Produto C', 30.00);

CREATE PROCEDURE InserirTransacao
    @Tipo CHAR(1), -- 'e' para ENTRADA, 's' para SAÍDA
    @Codigo_Transacao INT,
    @Codigo_Produto INT,
    @Quantidade INT
AS
BEGIN
    -- Declaração de variáveis
    DECLARE @Valor DECIMAL(10, 2);
    DECLARE @Valor_Total DECIMAL(10, 2);

    -- Verifica se o tipo é válido
    IF @Tipo NOT IN ('e', 's')
    BEGIN
        RAISERROR('Código inválido. Use ''e'' para ENTRADA ou ''s'' para SAÍDA.', 16, 1);
        RETURN;
    END

    -- Obtém o valor do produto
    SELECT @Valor = Valor
    FROM Produto
    WHERE Codigo = @Codigo_Produto;

    -- Verifica se o produto existe
    IF @Valor IS NULL
    BEGIN
        RAISERROR('Produto não encontrado.', 16, 1);
        RETURN;
    END

    -- Calcula o valor total
    SET @Valor_Total = @Valor * @Quantidade;

    -- Insere na tabela correta
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


EXEC InserirTransacao 'e', 2, 103, 10; -- Para inserir uma entrada
EXEC InserirTransacao 's', 1, 103, 5;  -- Para inserir uma saída

SELECT * FROM ENTRADA;
SELECT * FROM SAIDA;