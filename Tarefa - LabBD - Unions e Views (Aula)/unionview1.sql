CREATE DATABASE unionview1
GO
USE unionview1
GO
CREATE TABLE curso (
codigo_curso INT NOT NULL,
nome VARCHAR(250) NOT NULL,
sigla VARCHAR(10) NOT NULL
PRIMARY KEY (codigo_curso)
)
GO
CREATE TABLE palestra (
codigo_palestra INT NOT NULL,
titulo VARCHAR(MAX) NOT NULL,
carga_horaria INT NOT NULL,
data datetime NOT NULL,
codigo_palestrante INT NOT NULL
PRIMARY KEY (codigo_palestra)
FOREIGN KEY(codigo_palestrante) REFERENCES palestrante (codigo_palestrante)
)
GO
CREATE TABLE palestrante (
codigo_palestrante INT NOT NULL,
nome VARCHAR(250) NOT NULL,
empresa VARCHAR(100) NOT NULL
PRIMARY KEY (codigo_palestrante)
)
GO
CREATE TABLE aluno (
ra CHAR(7) NOT NULL,
nome VARCHAR(250) NOT NULL,
codigo_curso INT NOT NULL
PRIMARY KEY (ra)
FOREIGN KEY(codigo_curso) REFERENCES curso (codigo_curso)
)
GO
CREATE TABLE alunos_inscritos (
ra CHAR(7) NOT NULL,
codigo_palestra INT NOT NULL
PRIMARY KEY (ra, codigo_palestra)
FOREIGN KEY(ra) REFERENCES aluno (ra),
FOREIGN KEY(codigo_palestra) REFERENCES palestra (codigo_palestra)
)
GO
CREATE TABLE nao_alunos_inscritos (
rg VARCHAR(9) NOT NULL,
orgao_exp CHAR(5) NOT NULL,
codigo_palestra INT NOT NULL
PRIMARY KEY (rg, orgao_exp, codigo_palestra)
FOREIGN KEY(codigo_palestra) REFERENCES palestra (codigo_palestra),
FOREIGN KEY(rg, orgao_exp) REFERENCES nao_alunos (rg, orgao_exp)
)
GO
CREATE TABLE nao_alunos (
rg VARCHAR(9) NOT NULL,
orgao_exp CHAR(5) NOT NULL,
nome VARCHAR(250) NOT NULL
PRIMARY KEY (rg, orgao_exp)
)
GO

SELECT * FROM aluno
SELECT * FROM nao_alunos
SELECT * FROM nao_alunos_inscritos
SELECT * FROM curso
SELECT * FROM palestra
SELECT * FROM palestrante


CREATE VIEW lista_presenca
AS
SELECT a.ra AS Num_Documento, a.nome AS Nome_Pessoa, p.titulo AS Titulo_Palestra,
    pal.nome AS Nome_Palestrante, p.carga_horaria AS Carga_Horaria, p.data AS Data,
    CONVERT(VARCHAR(5), p.data, 108) AS Hora
FROM aluno a
JOIN alunos_inscritos ai
ON a.ra = ai.ra
JOIN palestra p
ON ai.codigo_palestra = p.codigo_palestra
JOIN palestrante pal
ON p.codigo_palestrante = pal.codigo_palestrante
UNION
SELECT CONCAT(na.rg, ' ', na.orgao_exp) AS Num_Documento, na.nome AS Nome_Pessoa,
    p.titulo AS Titulo_Palestra, pal.nome AS Nome_Palestrante, p.carga_horaria AS Carga_Horaria,
    p.data AS Data, CONVERT(VARCHAR(5), p.data, 108) AS Hora
FROM nao_alunos na
JOIN nao_alunos_inscritos nai
ON na.rg = nai.rg AND na.orgao_exp = nai.orgao_exp
JOIN palestra p
ON nai.codigo_palestra = p.codigo_palestra
JOIN palestrante pal
ON p.codigo_palestrante = pal.codigo_palestrante



SELECT * FROM lista_presenca
ORDER BY Nome_Pessoa ASC