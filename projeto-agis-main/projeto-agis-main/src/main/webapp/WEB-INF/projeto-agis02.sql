USE DbAgis

INSERT curso VALUES ('Analise e Desenvolvimento de Sistemas', 1800, 'ADS', 4.5)
SELECT * from curso
SELECT * FROM matricula

DECLARE @res BIT

EXEC insere_aluno '43628361877', 'ALUNO', '', '2004-09-08', '1194728111', '7281611193837', 'aluno@emai.com',
'aluno@fatec.sp.gov', '09-09-2009', 'EE Zazina', '90', '10', 1, @res OUT

PRINT @res

EXEC atualiza_aluno '202325494', '111111111', '2222222222', 'julia.font@email.com', 'julia.fontes14@fatec.sp'

SELECT * FROM aluno

SELECT aluno.ra, aluno.nome, curso.nome, aluno_detalhes.data_conclusao, emailCorporativo, emailPessoal FROM aluno, aluno_detalhes, matricula, curso
WHERE aluno.ra = aluno_detalhes.aluno_ra
AND aluno.ra = matricula.aluno_ra
AND curso.codigo = matricula.curso_codigo


SELECT * FROM aluno

SELECT disciplina.id, disciplina.nome, disciplina.dia_semana, disciplina.hora_comeco FROM disciplina 
WHERE disciplina.id IN (
SELECT disciplina.id FROM disciplina, matricula, curso WHERE matricula.curso_codigo = curso.codigo AND matricula.aluno_ra = '202325494'
 
SELECT aluno.nome, curso.codigo FROM curso, matricula, aluno
WHERE curso.codigo = matricula.curso_codigo
AND matricula.aluno_ra = aluno.ra
AND aluno.ra = '202322323'

SELECT * FROM disciplina, matricula_disciplina, aluno


SELECT * FROM dbo.consulta_chamada(1)


SELECT disciplina.id, disciplina.nome, disciplina.dia_semana, disciplina.hora_comeco FROM disciplina
WHERE disciplina.id NOT IN (SELECT disciplina_id FROM matricula_disciplina, matricula, curso WHERE matricula_disciplina.aluno_ra = '') 
AND disciplina.id IN (SELECT disciplina.id FROM disciplina, matricula, curso WHERE matricula.curso_codigo = curso.codigo AND matricula.aluno_ra = ''
AND matricula.curso_codigo = disciplina.curso_codigo)

INSERT INTO disciplina VALUES (1, 'Banco de Dados','LEANDRO','Ter�a-feira', '14:50:00', 4, 4)

SELECT * FROM consulta_disciplinas('202322323')

SELECT disciplina.id, disciplina.professor, matricula_disciplina.nota_final,SUM(frequencia.aulas) AS qtdeFaltas FROM aluno, aula, frequencia, disciplina, matricula_disciplina
WHERE aluno.ra = frequencia.aluno_ra AND aula.id = frequencia.aula_id
AND disciplina.id = aula.disciplina_id
AND aluno.ra = matricula_disciplina.aluno_ra AND matricula_disciplina.disciplina_id = disciplina.id
GROUP BY disciplina.id, matricula_disciplina.nota_final,disciplina.professor, aluno.nome


SELECT * FROM matricula_disciplina, disciplina

SELECT * FROM consulta_historico('202322323')


INSERT INTO disciplina VALUES (1, 'Logica de Programa��o','SATOSHI','Segunda-Feira', '14:50:00', 4, 1)
INSERT INTO disciplina VALUES (1, 'Arquitetura de Computadores','COLEVATI','Quarta-Feira', '14:50:00', 4, 1)