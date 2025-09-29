<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/bootstrap.min.css"/>
<script src="${pageContext.request.contextPath}/resources/js/jquery.min.js" defer></script>
<script src="${pageContext.request.contextPath}/resources/js/bootstrap.min.js" defer></script>
</head>
<body>
	<nav>
			<h2>AGIS</h2>
	</nav>
	<div class="p-2">
		<div>
			<a href="novoaluno" >Inserir Novo Aluno</a>
		</div>
		<div>
			<a href="matricula" >Matricular Disciplina</a>
		</div>
		<div>
			<a href="chamada" >Realizar Chamada</a>
		</div>
		
		<div>
			<a href="historico" >Consultar Historico</a>
		</div>
		
	</div>
	
</body>
</html>