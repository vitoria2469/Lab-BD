CREATE DATABASE DbAgis
GO
USE DbAgis
GO
CREATE TABLE aluno(
	ra VARCHAR(09),
	cpf VARCHAR(11),
	nome VARCHAR(200),
	dataNascimento DATE,
	emailPessoal VARCHAR(200),
	emailCorporativo VARCHAR(200),
	dataConclusao DATE,
	instituicaoSegundoGrau VARCHAR(200),
	pontuacao INT,
	posicao INT,
	PRIMARY KEY(ra)
)

GO
CREATE TABLE telefone(
	id INT IDENTITY(8001, 1),
	aluno_ra VARCHAR(09),
	telefone VARCHAR(11),
	PRIMARY KEY(id),
	FOREIGN KEY(aluno_ra) REFERENCES aluno(ra)
)
GO
CREATE TABLE curso(
	codigo INT IDENTITY(1,1),
	nome VARCHAR(200),
	carga_horaria INT,
	sigla VARCHAR(100),
	nota_enade DECIMAL(4,2),
	PRIMARY KEY(codigo)
)
GO
CREATE TABLE matricula(
	curso_codigo INT,
	aluno_ra VARCHAR(09),
	ano_ingresso INT,
	semestre_ingresso INT,
	ano_limite INT
)
GO
CREATE TABLE disciplina(
	id INT IDENTITY(1001, 1),
	curso_codigo INT,
	nome VARCHAR(200),
	professor VARCHAR(200),
	dia_semana VARCHAR(20),
	horaComeco TIME,
	horasAula INT,
	semestre INT,
	PRIMARY KEY(id),
	FOREIGN KEY(curso_codigo) REFERENCES curso(codigo)
)


CREATE TABLE aula(
	id INT IDENTITY(101,1) PRIMARY KEY,
	disciplina_id INT,
	dataAula DATE,
	FOREIGN KEY(disciplina_id) REFERENCES disciplina(id)
)

CREATE TABLE frequencia(
	id INT IDENTITY(10001, 1),
	aula_id INT,
	aluno_ra VARCHAR(09),
	aulas INT,
	PRIMARY KEY(id),
	FOREIGN KEY(aula_id) REFERENCES aula(id),
	FOREIGN KEY(aluno_ra) REFERENCES aluno(ra)
)

GO
CREATE TABLE matricula_disciplina(
	disciplina_id INT,
	aluno_ra VARCHAR(09),
	cursada BIT,
	nota_final DECIMAL(4,2),
	PRIMARY KEY(disciplina_id, aluno_ra),
	FOREIGN KEY(disciplina_id) REFERENCES disciplina(id),
	FOREIGN KEY(aluno_ra) REFERENCES aluno(ra)
)
GO
CREATE TABLE conteudo(
	id INT IDENTITY(10001,1),
	disciplina_id INT,
	nome VARCHAR(200),
	PRIMARY KEY(id),
	FOREIGN KEY(disciplina_id) REFERENCES disciplina(id)
)



CREATE PROCEDURE itera_numero(@cpf VARCHAR(11), @ite1 INT, @ite2 INT, @contador INT OUT)
AS
BEGIN
	WHILE(@ite1 > 0) BEGIN
		SET @contador = CAST(SUBSTRING(@cpf, @ite1, 1) AS INT) * @ite2 + @contador
		SET @ite1 = @ite1 - 1
		SET @ite2 = @ite2 - 1
	END
END


CREATE PROCEDURE valida_cpf(@cpf VARCHAR(11), @resultado BIT OUT)
AS
BEGIN
	DECLARE @ite1 INT
	DECLARE @ite2 INT
	DECLARE @contador INT

	SET @contador = 0
	SET @resultado = 0
	SET @ite1 = 9
	SET @ite2 = 10
	EXEC itera_numero @cpf, @ite1, @ite2, @contador OUT

	IF( ((@contador * 10) % 11) = (CAST(SUBSTRING(@cpf, 10, 1) AS INT)) ) BEGIN
		SET @contador = 0
		SET @ite1 = 10
		SET @ite2 = 11

		EXEC itera_numero @cpf, @ite1 , @ite2 , @contador OUT
	END
	IF((@contador * 10) % 11) = (CAST(SUBSTRING(@cpf, 11, 1) AS INT) ) BEGIN
		SET @resultado = 1
	END

END


CREATE PROCEDURE valida_idade(@data_nascimento DATE, @resultado BIT OUT)
AS
BEGIN
	SET @resultado = 0

	IF(DATEDIFF(YEAR, @data_nascimento, GETDATE()) >= 18) BEGIN
		SET @resultado = 1
	END 
END




CREATE PROCEDURE insere_aluno(@cpf VARCHAR(11), @nome VARCHAR(200), 
@nome_social VARCHAR(200), @data_nascimento DATE, @telefone1 VARCHAR(9), @telefone2 VARCHAR(9), @email_pessoal VARCHAR(200),
@email_corporativo VARCHAR(200), @data_conclusao_segundo_grau DATE,
@instituicao_segundo_grau VARCHAR(200), @pontuacao DECIMAL(4,2), @posicao INT, @curso_id INT)
AS
BEGIN
	DECLARE @cpf_valido BIT
	DECLARE @idade_valida BIT
	DECLARE @ano_ingresso INT
	DECLARE @semestre_ingresso INT
	DECLARE @semestre_limite INT
	DECLARE @ano_limite INT
	DECLARE @ra VARCHAR(20)


	SET @ano_ingresso = YEAR(GETDATE())

	SET @ano_limite = @ano_ingresso + 5
	
	IF(MONTH(GETDATE()) > 6) BEGIN
		SET @semestre_ingresso = 2
	END
	ELSE SET @semestre_ingresso = 1
	
	EXEC valida_cpf @cpf, @cpf_valido OUT
	EXEC valida_idade @data_nascimento, @idade_valida OUT

	IF(@idade_valida = 1) BEGIN
		IF(@cpf_valido = 1) BEGIN

			SET @ra = CONCAT(CAST(@ano_ingresso AS VARCHAR(06)), CAST(@semestre_ingresso AS VARCHAR(04)))
			DECLARE @contador INT
			SET @contador = 0

			WHILE(@contador < 4) BEGIN
				SET @ra = CONCAT(@ra, CAST(FLOOR(RAND() * 10) AS VARCHAR(02)))
				SET @contador = @contador + 1
			END

				INSERT INTO aluno(cpf, ra, nome, dataNascimento, emailPessoal, emailCorporativo, dataConclusao, pontuacao, posicao, instituicaoSegundoGrau) VALUES (@cpf, @ra,@nome, @data_nascimento, @email_pessoal, @email_corporativo, @data_conclusao_segundo_grau,@pontuacao, @posicao, @instituicao_segundo_grau)
				INSERT INTO telefone(aluno_ra, telefone) VALUES (@ra, @telefone1), (@ra, @telefone2)

				INSERT INTO matricula(aluno_ra, curso_codigo, ano_ingresso, semestre_ingresso, ano_limite) VALUES (@ra, @curso_id, @ano_ingresso, @semestre_ingresso, @ano_limite)
		END
	END
END



CREATE PROCEDURE atualiza_aluno(@ra VARCHAR(09), @telefone1 VARCHAR(11), @telefone2 VARCHAR(11), @emailPessoal VARCHAR(200), @emailCorporativo VARCHAR(200))
AS
BEGIN
	UPDATE aluno SET emailPessoal = @emailPessoal, emailCorporativo = @emailCorporativo WHERE ra = @ra
	UPDATE TOP (1) telefone SET telefone = @telefone1 WHERE aluno_ra = @ra
	UPDATE TOP (2) telefone SET telefone = @telefone2 WHERE aluno_ra = @ra
END
	

CREATE PROCEDURE adiciona_disciplina(@ra VARCHAR(09), @disciplinaId INT)
AS
BEGIN
	INSERT INTO matricula_disciplina(aluno_ra, disciplina_id) VALUES (@ra, @disciplinaId)
END

CREATE FUNCTION consulta_chamada(@disciplinaId INT)
RETURNS @tabela TABLE(
aluno_ra VARCHAR(09),
aluno_nome VARCHAR(200),
disciplina_nome VARCHAR(200)
)
AS
BEGIN
	INSERT INTO @tabela
	SELECT aluno.ra, aluno.nome, disciplina.nome FROM disciplina, matricula_disciplina, aluno
	WHERE matricula_disciplina.disciplina_id = @disciplinaId AND matricula_disciplina.disciplina_id = disciplina.id
	AND matricula_disciplina.aluno_ra = aluno.ra
	
	RETURN 
END

CREATE FUNCTION consulta_disciplinas(@ra VARCHAR(09))
RETURNS @disciplinas TABLE(
disciplina_id INT,
disciplina_nome VARCHAR(100),
diaSemana VARCHAR(100),
horaComeco TIME,
aulas INT
)
AS
BEGIN

	INSERT INTO @disciplinas
		SELECT disciplina.id, disciplina.nome, disciplina.dia_semana, disciplina.horaComeco, disciplina.horasAula FROM disciplina
		WHERE disciplina.id NOT IN (SELECT disciplina_id FROM matricula_disciplina, matricula, curso WHERE matricula_disciplina.aluno_ra = @ra) 
		AND disciplina.id IN (SELECT disciplina.id FROM disciplina, matricula, curso WHERE matricula.curso_codigo = curso.codigo AND matricula.aluno_ra = @ra
		AND matricula.curso_codigo = disciplina.curso_codigo)
	
	RETURN
END


CREATE FUNCTION consulta_historico(@ra VARCHAR(09))
RETURNS @historico TABLE(
codigoDisciplina INT,
nomeDisciplina VARCHAR(200),
professor VARCHAR(200),
notaFinal DECIMAL(4,2),
qtdeFaltas INT)
AS
BEGIN
	INSERT INTO @historico 
	SELECT disciplina.id, disciplina.nome, disciplina.professor, matricula_disciplina.nota_final,SUM(frequencia.aulas) AS qtdeFaltas FROM aluno, aula, frequencia, disciplina, matricula_disciplina
	WHERE aluno.ra = frequencia.aluno_ra AND aula.id = frequencia.aula_id
	AND disciplina.id = aula.disciplina_id
	AND aluno.ra = matricula_disciplina.aluno_ra AND matricula_disciplina.disciplina_id = disciplina.id
	AND aluno.ra = @ra
	GROUP BY aluno.nome,disciplina.id, matricula_disciplina.nota_final,disciplina.professor,disciplina.nome 
	RETURN
END

SELECT * FROM frequencia


CREATE PROCEDURE insere_aula(@disciplinaId INT, @id INT)
AS
BEGIN
	DECLARE @data_atual DATE
	SET @data_atual = GETDATE()
	INSERT INTO aula(disciplina_id, dataAula) VALUES (@disciplinaId, @data_atual)
	
END

CREATE PROCEDURE insere_frequencia(@aulaId INT, @alunoRa VARCHAR(09), @aulas INT)
AS
BEGIN
	INSERT INTO frequencia(aula_id, aluno_ra, aulas) VALUES (@aulaId, @alunoRa, @aulas)
END

CREATE TRIGGER matricula_disciplinas_primeiro_semestre ON aluno
AFTER INSERT
AS
	BEGIN
	DECLARE @id INT
	DECLARE @ra VARCHAR(09)
	SET @ra = (SELECT ra FROM inserted)
	DECLARE csr CURSOR FOR SELECT id FROM disciplina WHERE semestre = 1

	OPEN csr
	FETCH NEXT FROM csr INTO @id
	WHILE @@FETCH_STATUS = 0 BEGIN
		EXEC adiciona_disciplina @ra, @id
		FETCH NEXT FROM csr INTO @id
		END
	CLOSE csr
	END


