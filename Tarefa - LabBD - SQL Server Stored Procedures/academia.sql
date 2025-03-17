CREATE DATABASE academia;
USE academia;

CREATE TABLE Aluno (
    Codigo_aluno INT PRIMARY KEY,
    Nome VARCHAR(255) NOT NULL
);
GO
CREATE TABLE Atividade (
    Codigo INT PRIMARY KEY,
    Descricao VARCHAR(255) NOT NULL,
    IMC DECIMAL(5,2) NOT NULL
);
GO
INSERT INTO Atividade (Codigo, Descricao, IMC)
VALUES
(1, 'Corrida + Step', 18.5),
(2, 'Biceps + Costas + Pernas', 24.9),
(3, 'Esteira + Biceps + Costas + Pernas', 29.9),
(4, 'Bicicleta + Biceps + Costas + Pernas', 34.9),
(5, 'Esteira + Bicicleta', 39.9);

CREATE TABLE AtividadeAluno (
    Codigo_aluno INT,
    Altura DECIMAL(5,2) NOT NULL,
    Peso DECIMAL(5,2) NOT NULL,
    IMC DECIMAL(5,2) NOT NULL,
    Codigo_atividade INT,
    PRIMARY KEY (Codigo_aluno),
    FOREIGN KEY (Codigo_aluno) REFERENCES Aluno(Codigo_aluno),
    FOREIGN KEY (Codigo_atividade) REFERENCES Atividade(Codigo)
);

CREATE PROCEDURE CalcularIMC(IN altura DECIMAL(5,2), IN peso DECIMAL(5,2), OUT imc DECIMAL(5,2))
BEGIN
    SET imc = peso / (altura * altura);
END

CREATE PROCEDURE ObterAtividade(IN imc DECIMAL(5,2), OUT codigo_atividade INT)
BEGIN
    IF imc > 40 THEN
        SET codigo_atividade = 5;
    ELSE
        SELECT Codigo
        INTO codigo_atividade
        FROM Atividade
        WHERE IMC >= imc
        ORDER BY IMC ASC
        LIMIT 1;
    END IF;
END

CREATE PROCEDURE sp_alunoatividades(
    IN p_codigo_aluno INT,
    IN p_nome VARCHAR(255),
    IN p_altura DECIMAL(5,2),
    IN p_peso DECIMAL(5,2)
)
BEGIN
    DECLARE v_imc DECIMAL(5,2);
    DECLARE v_codigo_atividade INT;

    -- Se o código do aluno for nulo (inserção de novo registro)
    IF p_codigo_aluno IS NULL THEN
        -- Inserir o novo aluno
        INSERT INTO Aluno (Nome) VALUES (p_nome);
        SET p_codigo_aluno = LAST_INSERT_ID();  -- Pega o código do aluno recém inserido

        -- Calcular IMC
        CALL CalcularIMC(p_altura, p_peso, v_imc);

        -- Obter a atividade relacionada ao IMC
        CALL ObterAtividade(v_imc, v_codigo_atividade);

        -- Inserir dados na tabela AtividadeAluno
        INSERT INTO AtividadeAluno (Codigo_aluno, Altura, Peso, IMC, Codigo_atividade)
        VALUES (p_codigo_aluno, p_altura, p_peso, v_imc, v_codigo_atividade);

    -- Caso o código do aluno não seja nulo (atualizar registro existente)
    ELSE
        -- Verificar se o aluno já existe
        IF EXISTS (SELECT 1 FROM Aluno WHERE Codigo_aluno = p_codigo_aluno) THEN
            -- Calcular IMC
            CALL CalcularIMC(p_altura, p_peso, v_imc);

            -- Obter a atividade relacionada ao IMC
            CALL ObterAtividade(v_imc, v_codigo_atividade);

            -- Atualizar dados do aluno
            UPDATE Aluno SET Nome = p_nome WHERE Codigo_aluno = p_codigo_aluno;

            -- Atualizar dados na tabela AtividadeAluno
            UPDATE AtividadeAluno
            SET Altura = p_altura, Peso = p_peso, IMC = v_imc, Codigo_atividade = v_codigo_atividade
            WHERE Codigo_aluno = p_codigo_aluno;
        ELSE
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Aluno não encontrado';
        END IF;
    END IF;
END