
<%@ page import="listatarefas.Categoria" %>
<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8">
	<title>Tarefas</title>

	<meta name="layout" content="main">

</head>
<body>
	<header>
		<span>Lista de Categorias</span>
	</header>


	<div >
		<nav>
			<a href="/ListaTarefas/">Principal</a>
			<a href="/ListaTarefas/categoria/index">Lista Categorias</a>
		</nav>
	</div>

		<div id="show-categoria" class="div" role="main">
			<h1>Cadastrado:</h1>
			<g:if test="${flash.message}">
			<div class="message" role="status">${flash.message}</div>
			</g:if>
			<ol class="property-list categoria">
			
				<g:if test="${categoriaInstance?.nome}">
				<li class="fieldcontain">
					<span id="nome-label" class="property-label"><g:message code="categoria.nome.label" default="Nome: " /></span>
					
						<span class="property-value" aria-labelledby="nome-label"><g:fieldValue bean="${categoriaInstance}" field="nome"/></span>
					
				</li>
				</g:if>
			
			</ol>
			<g:form url="[resource:categoriaInstance, action:'delete']" method="DELETE">
				<nav>
					<g:link class="edit" action="edit" resource="${categoriaInstance}"><g:message code="default.button.edit.label" default="Edit" /></g:link>
					<g:actionSubmit class="delete" action="delete" value="${message(code: 'default.button.delete.label', default: 'Delete')}" onclick="return confirm('${message(code: 'default.button.delete.confirm.message', default: 'Are you sure?')}');" />
				</nav>
			</g:form>
		</div>
	<footer>Você tem <span id="taskCount">0</span> tarefas</footer>
	</body>
</html>
