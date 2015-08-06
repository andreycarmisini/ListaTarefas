<!DOCTYPE html>
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
		<div id="create-categoria" class="div" >


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
			<g:form url="[resource:categoriaInstance, action:'save']" >
				<fieldset class="form">
					<g:render template="form"/>
				</fieldset>
				<nav>
					<g:submitButton name="create" class="save" value="${message(code: 'default.button.create.label', default: 'Create')}" />
				</nav>
			</g:form>
		</div>
	<footer>Você tem <span id="taskCount">0</span> tarefas</footer>
	</body>
</html>
