
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
		<div id="show-tarefa" class="div" >

			<g:if test="${flash.message}">
			<div class="message" role="status">${flash.message}</div>
			</g:if>
			<ol class="property-list tarefa">
			
				<g:if test="${tarefaInstance?.descricao}">
				<li class="fieldcontain">
					<span id="descricao-label" class="property-label"><g:message code="tarefa.descricao.label" default="Descricao: " /></span>
					
						<span class="property-value" aria-labelledby="descricao-label"><g:fieldValue bean="${tarefaInstance}" field="descricao"/></span>
					
				</li>
				</g:if>
			
				<g:if test="${tarefaInstance?.deadline}">
				<li class="fieldcontain">
					<span id="deadline-label" class="property-label"><g:message code="tarefa.deadline.label" default="Deadline: " /></span>
					
						<span class="property-value" aria-labelledby="deadline-label"><g:formatDate date="${tarefaInstance?.deadline}" /></span>
					
				</li>
				</g:if>
			
				<g:if test="${tarefaInstance?.categoria}">
				<li class="fieldcontain">
					<span id="categoria-label" class="property-label"><g:message code="tarefa.categoria.label" default="Categoria: " /></span>
					
						<span class="property-value" aria-labelledby="categoria-label"><g:link controller="categoria" action="show" id="${tarefaInstance?.categoria?.id}">${tarefaInstance?.categoria?.encodeAsHTML()}</g:link></span>
					
				</li>
				</g:if>
			
			</ol>
			<g:form url="[resource:tarefaInstance, action:'delete']" method="DELETE">
				<nav>
					<g:link class="edit" action="edit" resource="${tarefaInstance}"><g:message code="default.button.edit.label" default="Edit" /></g:link>
					<g:actionSubmit class="delete" action="delete" value="${message(code: 'default.button.delete.label', default: 'Delete')}" onclick="return confirm('${message(code: 'default.button.delete.confirm.message', default: 'Are you sure?')}');" />
				</nav>
			</g:form>
		</div>
	<footer>Você tem <span id="taskCount">0</span> tarefas</footer>
	</body>
</html>
