<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix = "c" uri = "http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Matricular Novo Aluno</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/bootstrap.min.css"/>
<script src="${pageContext.request.contextPath}/resources/js/jquery.min.js" defer></script>
<script src="${pageContext.request.contextPath}/resources/js/bootstrap.min.js" defer></script>
</head>
<body>
	<nav>
		<a href="/">
			<h2>AGIS</h2>
		</a>
	</nav>
	<form action="novoaluno" method="POST" class="container grid">
		<div class="form-group">
			<label>CPF: </label>
		<input type="text" name="cpf"/>
	
		<label>Nome: </label>
		<input type="text" name="nome"/>
		</div>
		
		<div class="form-group">
			<label>Nome Social: </label>
			<input type="text" name="nomeSocial" />
		
			<label>Data de Nascimento</label>
			<input type="date" name="dataNascimento" />	
		</div>
		
		<div class="form=-group">
			<label>Telefone 1: </label>	
			<input type="text" name="telefone" />
		
			<label>Telefone 2: </label>
			<input type="text" name="telefone" />
		</div>
		
		<div class="form-group">
			<label>Email Pessoal: </label>
		<input type="text" name="emailPessoal" />
		
		<label>Email Corporativo: </label>
		<input type="text" name="emailCorporativo" />
		</div>
		
		<div class="form-group">
			<label>Data de Conclusão Segundo Grau</label>
		<input type="date" name="dataConclusaoSegundoGrau" />
		
		<label>Instituição Segundo Grau</label>
		<input type="text" name="instituicaoSegundoGrau" />
		</div>
		
		<div class="form-group">
			<label>Pontuação</label>
		<input type="number" name="pontuacao" />
		
		<label>Posição</label>
		<input type="number" name="posicao" />
		</div>
		
	
	
	
		<label>Curso: </label>
		<select name="matricula.curso.codigo">
			<c:forEach var="curso" items="${cursos }">
				<option value="${curso.codigo }">
					<c:out value="${curso.nome }" />
				</option>
			</c:forEach>
		</select>
		
		<input type="submit" />
	</form>
</body>
</html>