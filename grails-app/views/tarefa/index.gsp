


<%@ page import="listatarefas.Tarefa" %>
<!DOCTYPE html>
<html>
<head>
	<meta name="layout" content="main">
	<g:set var="entityName" value="${message(code: 'tarefa.label', default: 'Tarefa')}" />
	<title><g:message code="default.list.label" args="[entityName]" /></title>
</head>
<body>
<a href="#list-tarefa" class="skip" tabindex="-1"><g:message code="default.link.skip.label" default="Skip to content&hellip;"/></a>
<div class="nav" role="navigation">
	<ul>
		<li><a class="home" href="${createLink(uri: '/')}"><g:message code="default.home.label"/></a></li>
		<li><g:link class="create" action="create"><g:message code="default.new.label" args="[entityName]" /></g:link></li>
	</ul>
</div>
<div id="list-tarefa" class="content scaffold-list" role="main">
	<h1><g:message code="default.list.label" args="[entityName]" /></h1>
	<g:if test="${flash.message}">
		<div class="message" role="status">${flash.message}</div>
	</g:if>
	<table>
		<thead>
		<tr>

			<g:sortableColumn property="descricao" title="${message(code: 'tarefa.descricao.label', default: 'Descricao')}" />

			<g:sortableColumn property="deadline" title="${message(code: 'tarefa.deadline.label', default: 'Deadline')}" />

			<th><g:message code="tarefa.categoria.label" default="Categoria" /></th>
			<th><g:message code="tarefa.categoria.label" default="Opções" /></th>

		</tr>
		</thead>
		<tbody>
		<g:each in="${tarefaInstanceList}" status="i" var="tarefaInstance">
			<tr class="${((i % 2) == 0 ? 'even' : 'odd')}
			${(tarefaInstance.deadline < new Date() - 1 ? 'overdue' : 'null')}
			${((((tarefaInstance.deadline.time - (new Date()-1).time) / (24 * 60 * 60 * 1000)) <= 5) &&
					(((tarefaInstance.deadline.time - (new Date()-1).time) / (24 * 60 * 60 * 1000)) >= 0) ? 'warning': 'null')}">



				<td class="${tarefaInstance.concluido ? 'taskCompleted': ''}"><g:link action="show" id="${tarefaInstance.id}">${fieldValue(bean: tarefaInstance, field: "descricao")}</g:link></td>

				<td class="${tarefaInstance.concluido ? 'taskCompleted': ''}"><g:formatDate format="dd-MM-yyyy" date="${tarefaInstance.deadline}" /></td>

				<td class="${tarefaInstance.concluido ? 'taskCompleted': ''}">${fieldValue(bean: tarefaInstance, field: "categoria")}</td>

				<td>
					<g:form url="[resource:tarefaInstance, action:'delete']" method="DELETE">
						<fieldset class="buttons">
							<g:if test="${!tarefaInstance.concluido}">
								<g:link class="edit" action="edit" resource="${tarefaInstance}"><g:message code="default.button.edit.label" default="Edit" /></g:link>
							</g:if>
							<g:actionSubmit class="delete" action="delete" value="${message(code: 'default.button.delete.label', default: 'Delete')}" onclick="return confirm('${message(code: 'default.button.delete.confirm.message', default: 'Você tem certeza?')}');" />
							<g:if test="${!tarefaInstance.concluido}">
								<g:actionSubmit action="concluir" value="Concluir"/>
							</g:if>
						</fieldset>
					</g:form>
				</td>

			</tr>
		</g:each>
		</tbody>
	</table>
	<center> <strong>Você tem: ${tarefaInstanceCount - tarefasConcluidasCount} tarefas</strong></center></div> </br>
<div class="pagination">
	<g:paginate total="${tarefaInstanceCount ?: 0}" />
</div>
</div>
</body>
</html>
