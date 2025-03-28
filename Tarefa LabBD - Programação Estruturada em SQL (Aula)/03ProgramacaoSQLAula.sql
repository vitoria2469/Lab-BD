--1) Fazer em SQL Server os seguintes algoritmos:

--a) Dado um n�mero inteiro. Calcule e mostre o seu fatorial. (N�o usar entrada superior a 12)

DECLARE @numero INT = 8;
DECLARE @fatorial INT = 1;

WHILE @numero > 1
BEGIN
    SET @fatorial = @fatorial * @numero;
    SET @numero = @numero - 1;
END

SELECT @fatorial AS Fatorial;



--b) Dados A, B, e C de uma equa��o do 2o grau da f�rmula AX2+BX+C=0. Verifique e mostre a
--exist�ncia de ra�zes reais e se caso exista, calcule e mostre. Caso n�o existam, exibir mensagem.

DECLARE @A FLOAT = 1;
DECLARE @B FLOAT = -3;
DECLARE @C FLOAT = 2;
DECLARE @delta FLOAT;
DECLARE @raiz1 FLOAT;
DECLARE @raiz2 FLOAT;

SET @delta = @B * @B - 4 * @A * @C;

IF @delta > 0
BEGIN
    SET @raiz1 = (-@B + SQRT(@delta)) / (2 * @A);
    SET @raiz2 = (-@B - SQRT(@delta)) / (2 * @A);
    SELECT 'Ra�zes reais distintas: ' AS Mensagem, @raiz1 AS Raiz1, @raiz2 AS Raiz2;
END
ELSE IF @delta = 0
BEGIN
    SET @raiz1 = -@B / (2 * @A);
    SELECT 'Raiz real �nica: ' AS Mensagem, @raiz1 AS Raiz;
END
ELSE
BEGIN
    SELECT 'N�o existem ra�zes reais' AS Mensagem;
END



--c) Calcule e mostre quantos anos ser�o necess�rios para que Ana seja maior que Maria sabendo
--que Ana tem 1,10 m e cresce 3 cm ao ano e Maria tem 1,5 m e cresce 2 cm ao ano.

DECLARE @altura_ana FLOAT = 1.10;
DECLARE @altura_maria FLOAT = 1.50;
DECLARE @crescimento_ana FLOAT = 0.03;
DECLARE @crescimento_maria FLOAT = 0.02;
DECLARE @anos INT = 0;

WHILE @altura_ana <= @altura_maria
BEGIN
    SET @altura_ana = @altura_ana + @crescimento_ana;
    SET @altura_maria = @altura_maria + @crescimento_maria;
    SET @anos = @anos + 1;
END

SELECT @anos AS Anos_necessarios;



--d) Seja a seguinte s�rie: 1, 4, 4, 2, 5, 5, 3, 6, 6, 4, 7, 7, ...
--Escreva uma aplica��o que a escreva N termos

DECLARE @N INT = 10;
DECLARE @i INT = 1;
DECLARE @termo INT;

WHILE @i <= @N
BEGIN
    IF @i % 2 <> 0
    BEGIN
        SET @termo = ( @i + 1 ) / 2;
    END
    ELSE
    BEGIN
        SET @termo = @i / 2;
    END

    PRINT @termo;

    SET @i = @i + 1;
END


/*
e) Considerando a tabela abaixo, gere uma database, a tabela e crie um algoritmo para inserir
uma massa de dados, com 50 registros, para fins de teste, com as regras estabelecidas (N�o
usar constraints na cria��o da tabela)

Produto
Codigo Nome Valor Vencimento
INT (PK) VARCHAR(30) DECIMAL(7,2) DATE

� C�digo inicia em 50001 e incrementa de 1 em 1
� Nome segue padr�o simples: Produto 1, Produto 2, Produto 3, etc.
� Valor, gerar um n�mero aleat�rio* entre 10.00 e 100.00
� Vencimento, gerar um n�mero aleat�rio* entre 3 e 7 e, usando a fun��o espec�fica para
soma de datas no SQL Server, somar o valor gerado � data de hoje.

* Fun��o RAND() gera n�meros aleat�rios entre 0 e 0,9999...
*/

CREATE DATABASE TesteProduto;
GO
USE TesteProduto;
GO
CREATE TABLE Produto (
    Codigo INT,
    Nome VARCHAR(30),
    Valor DECIMAL(7, 2),
    Vencimento DATE
);
GO

DECLARE @i INT = 1;
DECLARE @codigo INT = 50001;
DECLARE @nome VARCHAR(30);
DECLARE @valor DECIMAL(7, 2);
DECLARE @vencimento DATE;

WHILE @i <= 50
BEGIN
    SET @nome = 'Produto ' + CAST(@i AS VARCHAR(30));

    SET @valor = 10 + (RAND() * 90);

    SET @vencimento = DATEADD(DAY, (3 + FLOOR(RAND() * 5)), GETDATE());

    INSERT INTO Produto (Codigo, Nome, Valor, Vencimento)
    VALUES (@codigo, @nome, @valor, @vencimento);

    SET @codigo = @codigo + 1;
    
    SET @i = @i + 1;
END
GO



/*
f) Considerando a tabela abaixo, gere uma database, a tabela e crie um algoritmo para inserir
uma massa de dados, com 50 registros, para fins de teste, com as regras estabelecidas (N�o
usar constraints na cria��o da tabela)

Livro
ID T�tulo Qtd_P�ginas Qtd_Estoque
INT (PK) VARCHAR(30) INT INT

� C�digo inicia em 981101 e incrementa de 1 em 1
� T�tulo segue padr�o simples: Livro 981101, Livro 981102, Livro 981103, etc.
� Qtd_paginas deve ser um n�mero aleat�rio entre 100 e 400
� Qtd_Estoque deve ser um n�mero aleat�rio entre 2 e 20
*/

CREATE DATABASE TesteLivro;
GO
USE TesteLivro;
GO
CREATE TABLE Livro (
    ID INT,
    T�tulo VARCHAR(30),
    Qtd_P�ginas INT,
    Qtd_Estoque INT
);
GO

DECLARE @i INT = 1;
DECLARE @ID INT = 981101;
DECLARE @titulo VARCHAR(30);
DECLARE @qtd_paginas INT;
DECLARE @qtd_estoque INT;

WHILE @i <= 50
BEGIN
    SET @titulo = 'Livro ' + CAST(@ID AS VARCHAR(30));

    SET @qtd_paginas = 100 + FLOOR(RAND() * 301);

    SET @qtd_estoque = 2 + FLOOR(RAND() * 19);

    INSERT INTO Livro (ID, T�tulo, Qtd_P�ginas, Qtd_Estoque)
    VALUES (@ID, @titulo, @qtd_paginas, @qtd_estoque);

    SET @ID = @ID + 1;
    
    SET @i = @i + 1;
END
GO