<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix = "c" uri = "http://java.sun.com/jsp/jstl/core" %>   
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>AGIS - Historico</title>
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
	<form action="historico" method="POST">
		<label>Aluno: </label>
		<select name="ra">
			<c:forEach var="aluno" items="${alunos }">
				<option value="${aluno.ra }">
					<c:out value="${aluno.nome }" />
				</option>
			</c:forEach>
		</select>
		<input type="submit" class="btn" value="Listar"/>
	</form>
	
	<c:forEach var="historico" items="${historicos }">
		<div>
			<div><c:out value="${historico.nomeDisciplina }"/></div>
			<div><c:out value="${historico.qtdeFaltas }" /></div>
			<div><c:out value="${historico.professor }" /></div>
		</div>
	
	</c:forEach>
</body>
</html>