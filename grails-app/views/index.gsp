<%@ page import="listatarefas.Tarefa" %>
<%@ page import="listatarefas.Categoria" %>
<!DOCTYPE html>
<html lang="en">
<head>
	<meta charset="utf-8">
	<title>Tarefas</title>
	<link rel="stylesheet" href="assets/tasks.css"/>

	<script src="assets/jquery.validate.js" type="text/javascript" ></script>
	<script src="assets/date.js" type="text/javascript" ></script>
	<script src="assets/jquery.tmpl.js" type="text/javascript" ></script>
	<script src="assets/jquery-serialization.js" type="text/javascript" ></script>
	<script src="assets/tasks-controller.js" type="text/javascript" ></script>
	<script src="assets/tasks-webstorage.js" type="text/javascript" ></script>


	<meta name="layout" content="main">

</head>
<body>
<header>
	<span>Lista de Tarefas</span>
</header>

<main id="taskPage">
	<section id="taskCreation" class="not">
		<g:form controller="tarefa"  action="save" >


			<input type="hidden" name="id" />
			<input type="hidden" name="completed" />


			<div  class="${hasErrors(bean: tarefaInstance, field: 'descricao', 'error')} required">
				<label for="descricao">
					<g:message code="tarefa.descricao.label" default="Descricao" />
					<span class="required-indicator">*</span>
				</label>
				<g:textField name="descricao" required="" value="${tarefaInstance?.descricao}"/>

			</div>

			<div  class="${hasErrors(bean: tarefaInstance, field: 'deadline', 'error')} required">
				<label for="deadline">
					<g:message code="tarefa.deadline.label" default="Deadline" />
					<span class="required-indicator">*</span>
				</label>
				<g:datePicker name="deadline" precision="day"  value="${tarefaInstance?.deadline}"  />

			</div>

			<div class="${hasErrors(bean: tarefaInstance, field: 'categoria', 'error')} required">
				<label for="categoria">
					<g:message code="tarefa.categoria.label" default="Categoria" />
					<span class="required-indicator">*</span>
				</label>
				<g:select id="categoria" name="categoria.id" from="${listatarefas.Categoria.list()}" optionKey="id" required="" value="${tarefaInstance?.categoria?.id}" class="many-to-one"/>

			</div>


			<nav>

				<g:submitButton name="create" class="save" value="Salvar tarefa" />
				<a href="#" id="clearTask">Limpar tarefa</a>

			</nav>
		</g:form>
	</section>
	<section>
		<table id="tblTasks">
			<colgroup>
				<col width="40%">
				<col width="15%">
				<col width="15%">
				<col width="30%">
			</colgroup>
			<thead>
			<tr>
				<th>Nome</th>
				<th>Deadline</th>
				<th>Categoria</th>
				<th>Ações</th>

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
		<nav>
			<a href="#" id="btnAddTask">Adicionar tarefa</a>
			<a href="categoria">Gerenciar Categorias</a>
		</nav>
	</section>
</main>
<script id="taskRow" type="text/x-jQuery-tmpl">
	<tr id="{{= id }}">
		<td>{{= task }}</td>
		<td><time datetime="{{= requiredBy }}"> {{= requiredBy }}</time></td>
		<td>{{= category_desc }}</td>
		<td>
			<nav>
				<a href="#" class="editRow" data-task-id="{{= id }}">Editar</a>
				<a href="#" class="completedRow" data-task-id="{{= id }}">Completar</a>
				<a href="#" class="deleteRow" data-task-id="{{= id }}">Deletar</a>
			</nav>
		</td>
	</tr>
</script>


<script>
	$(document).ready(function() {
		tasksController.init($('#taskPage'), function() {
			tasksController.loadTasks();
		});
		//tasksController.init($('#taskPage'));
		//tasksController.loadTasks();
	});
</script>


<footer>Você tem: <span id="taskCount">0</span> tarefas</footer>


</body>

</html>







