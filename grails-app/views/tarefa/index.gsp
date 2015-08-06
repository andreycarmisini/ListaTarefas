<%@ page import="listatarefas.Tarefa" %>
<!DOCTYPE html>
<html>
<<head>
	<meta charset="utf-8">
	<title>Tarefas</title>






	<meta name="layout" content="main">

</head>
<body>
<header>
	<span>Lista de Tarefas</span>
</header>

<main id="taskPage">
	<section id="taskCreation" class="not">
		<g:form url="[resource:tarefaInstance, action:'save']" >
			<input type="hidden" name="id" />
			<input type="hidden" name="completed" />
			<div>
				<label>Tarefa</label>

				<g:textField name="descricao" placeholder="Estudar e programar" required="required" maxlength="200" value="${tarefaInstance?.descricao}"/>
			</div>
			<div>
				<label>Finalizar até</label>
				<g:datePicker name="deadline" precision="day"  value="${tarefaInstance?.deadline}"  />
			</div>
			<div>
				<label>Categoria</label>
				<g:select id="categoria" name="categoria.id" from="${listatarefas.Categoria.list()}" optionKey="id" required="" value="${tarefaInstance?.categoria?.id}" class="many-to-one"/>
			</div>
			<nav>
				<g:submitButton name="create" value="Salvar tarefa" />
				<input type='reset' value='Limpar tarefa' />
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


					<td class="${tarefaInstance.concluido ? 'taskCompleted': ''}">${fieldValue(bean: tarefaInstance, field: "descricao")}</td>

						<td class="${tarefaInstance.concluido ? 'taskCompleted': ''}"><g:formatDate format="dd-MM-yyyy" date="${tarefaInstance.deadline}" /></td>

						<td class="${tarefaInstance.concluido ? 'taskCompleted': ''}">${fieldValue(bean: tarefaInstance, field: "categoria")}</td>

						<td>
							<g:form url="[resource:tarefaInstance, action:'delete']" method="DELETE">
								<nav>
									<g:if test="${!tarefaInstance.concluido}">
										<g:link class="edit" action="edit" resource="${tarefaInstance}"><g:message code="default.button.edit.label" default="Edit" /></g:link>
									</g:if>
									<g:actionSubmit class="delete" action="delete" value="${message(code: 'default.button.delete.label', default: 'Delete')}" onclick="return confirm('${message(code: 'default.button.delete.confirm.message', default: 'Are you sure?')}');" />
									<g:if test="${!tarefaInstance.concluido}">
										<g:link   action="concluir" resource="${tarefaInstance}">
											<g:message code="default.button.complete.label" default="Completar" />
										</g:link>
									</g:if>
								</nav>
							</g:form>
						</td>

					</tr>
				</g:each>

			</tbody>
		</table>
		<nav>
			<a href="#" id="btnAddTask">Adicionar tarefa</a>
			<a href="/ListaTarefas/categoria/create">Gerenciar Categorias</a>
		</nav>


	</section>
</main>



<script>
	$(document).ready(function() {
		tasksController.init($('#taskPage'), function() {
			tasksController.loadTasks();
		});
		//tasksController.init($('#taskPage'));
		//tasksController.loadTasks();
	});
</script>

<footer>Você tem ${tarefaInstanceCount - tarefasConcluidasCount} tarefas</footer>


</body>

</html>