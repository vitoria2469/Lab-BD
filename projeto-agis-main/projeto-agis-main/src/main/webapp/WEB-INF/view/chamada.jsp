<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix = "c" uri = "http://java.sun.com/jsp/jstl/core" %>    
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>AGIS - Chamada</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/bootstrap.min.css"/>
<script src="${pageContext.request.contextPath}/resources/js/jquery.min.js" defer></script>
<script src="${pageContext.request.contextPath}/resources/js/bootstrap.min.js" defer></script>
</head>
<body class="">
	<nav>
		<a href="/">
			<h2>AGIS</h2>
		</a>
	</nav>
	<div class="container fluid">
	<form action="listarAlunos" method="GET">
		Disciplina: 
		<select name="disciplinaId">
			<c:forEach var="disciplina" items="${disciplinas }">
				<option value="${disciplina.id }">
					<c:out value="${disciplina.nome }" />
				</option>
			</c:forEach>
		</select>
		<input type="submit" value="Listar" class="btn"/>
	</form>
	
	<form action="chamada" method="POST" class="form">
		<c:out value="${disciplina.aulasHora }"/>
		<table class="table table-sm">
			<thead>
				<th>Aluno</th>
				<th>Aulas</th>
			</thead>
			<tbody>
				<c:forEach var="aluno" items="${alunos }">
					<tr>
						<td><c:out value="${aluno.nome }"></c:out></td>
						<td><input type="hidden" name="ra" value="${aluno.ra }" /></td>
						<input type="hidden" name="disciplinaId" value="<c:out value='${disciplina.id }' />" />
						<td><input type="number" name="aulas" min="0" max="${disciplina.aulasHora }" required/></td>
					</tr>
					
			</c:forEach>
			</tbody>
		</table>
		
	
		<input type="submit" class="btn"/>
	</form>
	</div>

</body>
</html>