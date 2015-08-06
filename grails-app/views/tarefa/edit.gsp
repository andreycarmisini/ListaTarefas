<%@ page import="listatarefas.Tarefa" %>
<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8">
	<title>Tarefas</title>

	<meta name="layout" content="main">

</head>
<body>
<header>
	<span>Lista de Tarefa</span>
</header>


	<div >
		<nav>
			<a href="/ListaTarefas/">Principal</a>
			<a href="/ListaTarefas/tarefa/index">Lista Tarefas</a>
		</nav>
	</div>
		<div id="edit-tarefa" class="div" >

			<g:if test="${flash.message}">
			<div class="message" role="status">${flash.message}</div>
			</g:if>
			<g:hasErrors bean="${tarefaInstance}">
			<ul class="errors" role="alert">
				<g:eachError bean="${tarefaInstance}" var="error">
				<li <g:if test="${error in org.springframework.validation.FieldError}">data-field-id="${error.field}"</g:if>><g:message error="${error}"/></li>
				</g:eachError>
			</ul>
			</g:hasErrors>
			<g:form url="[resource:tarefaInstance, action:'update']" method="PUT" >
				<g:hiddenField name="version" value="${tarefaInstance?.version}" />
				<fieldset class="form">
					<g:render template="form"/>
				</fieldset>
				<nav>
					<g:actionSubmit class="save" action="update" value="${message(code: 'default.button.update.label', default: 'Update')}" />
				</nav>
			</g:form>
		</div>
	<footer></footer>
	</body>
</html>
