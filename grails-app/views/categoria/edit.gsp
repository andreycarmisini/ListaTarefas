<%@ page import="listatarefas.Categoria" %>
<!DOCTYPE html>
<head>
	<meta charset="utf-8">
	<title>Tarefas</title>

	<meta name="layout" content="main">

</head>
<body>
<header>
	<span>Edição de Categoria</span>
</header>


		<div >
			<nav>
				<a href="/ListaTarefas/">Principal</a>
				<a href="/ListaTarefas/categoria/index">Lista Categorias</a>
			</nav>
		</div>
		<div id="create-categoria2" class="div" >

			<h1><g:message code="default.edit.label" args="[entityName]" /></h1>
			<g:if test="${flash.message}">
			<div class="message" role="status">${flash.message}</div>
			</g:if>
			<g:hasErrors bean="${categoriaInstance}">
			<ul class="errors" role="alert">
				<g:eachError bean="${categoriaInstance}" var="error">
				<li <g:if test="${error in org.springframework.validation.FieldError}">data-field-id="${error.field}"</g:if>><g:message error="${error}"/></li>
				</g:eachError>
			</ul>
			</g:hasErrors>
			<g:form url="[resource:categoriaInstance, action:'update']" method="PUT" >
				<g:hiddenField name="version" value="${categoriaInstance?.version}" />
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
