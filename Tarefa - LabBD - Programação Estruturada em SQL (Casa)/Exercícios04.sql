--Exercícios:
--1) Fazer em SQL Server os seguintes algoritmos:
--a) Fazer um algoritmo que leia 1 número e mostre se são múltiplos de 2,3,5 ou nenhum deles

DECLARE @numero INT
SET @numero = 15  -- Substitua por qualquer número desejado

IF @numero % 2 = 0
    PRINT 'Múltiplo de 2'
ELSE IF @numero % 3 = 0
    PRINT 'Múltiplo de 3'
ELSE IF @numero % 5 = 0
    PRINT 'Múltiplo de 5'
ELSE
    PRINT 'Nenhum múltiplo de 2, 3 ou 5'

--b) Fazer um algoritmo que leia 3 números e mostre o maior e o menor

DECLARE @num1 INT, @num2 INT, @num3 INT
SET @num1 = 10  -- Substitua pelos números desejados
SET @num2 = 20
SET @num3 = 5

-- Verificando o maior
IF @num1 >= @num2 AND @num1 >= @num3
    PRINT 'Maior: ' + CAST(@num1 AS VARCHAR)
ELSE IF @num2 >= @num1 AND @num2 >= @num3
    PRINT 'Maior: ' + CAST(@num2 AS VARCHAR)
ELSE
    PRINT 'Maior: ' + CAST(@num3 AS VARCHAR)

-- Verificando o menor
IF @num1 <= @num2 AND @num1 <= @num3
    PRINT 'Menor: ' + CAST(@num1 AS VARCHAR)
ELSE IF @num2 <= @num1 AND @num2 <= @num3
    PRINT 'Menor: ' + CAST(@num2 AS VARCHAR)
ELSE
    PRINT 'Menor: ' + CAST(@num3 AS VARCHAR)

--c) Fazer um algoritmo que calcule os 15 primeiros termos da série
--1,1,2,3,5,8,13,21,...
--E calcule a soma dos 15 termos

DECLARE @termo1 INT = 1, @termo2 INT = 1, @proximoTermo INT, @soma INT = 0, @contador INT = 0

-- Calculando os 15 primeiros termos da série Fibonacci
WHILE @contador < 15
BEGIN
    SET @proximoTermo = @termo1 + @termo2
    PRINT @termo1  -- Exibe o termo atual
    SET @soma = @soma + @termo1

    -- Atualizando os termos
    SET @termo1 = @termo2
    SET @termo2 = @proximoTermo
    SET @contador = @contador + 1
END

-- Exibe a soma dos 15 termos
PRINT 'Soma dos 15 termos: ' + CAST(@soma AS VARCHAR)

--d) Fazer um algoritmo que separa uma frase, colocando todas as letras em maiúsculo e em
--minúsculo (Usar funções UPPER e LOWER)

DECLARE @frase VARCHAR(100)
SET @frase = 'Pokemon temos que pegar'

-- Exibe a frase em maiúsculas
PRINT UPPER(@frase)

-- Exibe a frase em minúsculas
PRINT LOWER(@frase)

--e) Fazer um algoritmo que inverta uma palavra (Usar a função SUBSTRING)

DECLARE @palavra VARCHAR(100)
SET @palavra = 'Pokemon'

DECLARE @comprimento INT = LEN(@palavra)
DECLARE @inversa VARCHAR(100) = ''

-- Invertendo a palavra
WHILE @comprimento > 0
BEGIN
    SET @inversa = @inversa + SUBSTRING(@palavra, @comprimento, 1)
    SET @comprimento = @comprimento - 1
END

-- Exibe a palavra invertida
PRINT @inversa

/*
f) Considerando a tabela abaixo, gere uma massa de dados, com 100 registros, para fins de teste
com as regras estabelecidas (Não usar constraints na criação da tabela)

Computador
ID Marca QtdRAM TipoHD QtdHD FreqCPU
INT (PK) VARCHAR(40) INT VARCHAR(10) INT DECIMAL(7,2)

• ID incremental a iniciar de 10001
• Marca segue o padrão simples, Marca 1, Marca 2, Marca 3, etc.
• QtdRAM é um número aleatório* dentre os valores permitidos (2, 4, 8, 16)
• TipoHD segue o padrão:
o Se o ID dividido por 3 der resto 0, é HDD
o Se o ID dividido por 3 der resto 1, é SSD
o Se o ID dividido por 3 der resto 2, é M2 NVME
• QtdHD segue o padrão:
o Se o TipoHD for HDD, um valor aleatório* dentre os valores permitidos (500, 1000 ou 2000)
o Se o TipoHD for SSD, um valor aleatório* dentre os valores permitidos (128, 256, 512)
• FreqHD é um número aleatório* entre 1.70 e 3.20

* Função RAND() gera números aleatórios entre 0 e 0,9999...
*/

CREATE TABLE Computador (
    ID INT PRIMARY KEY,
    Marca VARCHAR(40),
    QtdRAM INT,
    TipoHD VARCHAR(10),
    QtdHD INT,
    FreqCPU DECIMAL(7,2)
)

DECLARE @i INT = 10001
DECLARE @marca VARCHAR(40)
DECLARE @qtdRAM INT
DECLARE @tipoHD VARCHAR(10)
DECLARE @qtdHD INT
DECLARE @freqCPU DECIMAL(7,2)

WHILE @i < 10101
BEGIN
    -- Gerando a marca
    SET @marca = 'Marca ' + CAST(@i - 10000 AS VARCHAR)

    -- Gerando a quantidade de RAM (2, 4, 8, 16)
    SET @qtdRAM = (CASE WHEN RAND() * 4 < 1 THEN 2
                        WHEN RAND() * 4 < 2 THEN 4
                        WHEN RAND() * 4 < 3 THEN 8
                        ELSE 16 END)

    -- Definindo o TipoHD baseado no ID
    IF @i % 3 = 0
        SET @tipoHD = 'HDD'
    ELSE IF @i % 3 = 1
        SET @tipoHD = 'SSD'
    ELSE
        SET @tipoHD = 'M2 NVME'

    -- Gerando a quantidade de HD com base no TipoHD
    IF @tipoHD = 'HDD'
        SET @qtdHD = (CASE WHEN RAND() * 3 < 1 THEN 500
                           WHEN RAND() * 3 < 2 THEN 1000
                           ELSE 2000 END)
    ELSE IF @tipoHD = 'SSD'
        SET @qtdHD = (CASE WHEN RAND() * 3 < 1 THEN 128
                           WHEN RAND() * 3 < 2 THEN 256
                           ELSE 512 END)
    ELSE
        SET @qtdHD = (CASE WHEN RAND() * 3 < 1 THEN 500
                           WHEN RAND() * 3 < 2 THEN 1000
                           ELSE 2000 END)

    -- Gerando a frequência da CPU entre 1.70 e 3.20
    SET @freqCPU = 1.70 + (RAND() * (3.20 - 1.70))

    -- Inserindo o registro na tabela
    INSERT INTO Computador (ID, Marca, QtdRAM, TipoHD, QtdHD, FreqCPU)
    VALUES (@i, @marca, @qtdRAM, @tipoHD, @qtdHD, @freqCPU)

    SET @i = @i + 1
END
