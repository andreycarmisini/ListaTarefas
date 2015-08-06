
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

	<section id="categoria">

		<div >
			<nav>
				<a href="/ListaTarefas/">Principal</a>
				<a href="/ListaTarefas/categoria/create">Nova Categoria</a>
			</nav>
		</div>
		<div id="list-categoria" class="content scaffold-list" role="main">

			<table>
				<thead>
				<tr>

					<th>Descrição</th>

				</tr>
				</thead>
				<tbody>
					<g:each in="${categoriaInstanceList}" status="i" var="categoriaInstance">
						<tr class="${(i % 2) == 0 ? 'even' : 'odd'}">

							<td><g:link action="show" id="${categoriaInstance.id}">${fieldValue(bean: categoriaInstance, field: "nome")}</g:link></td>

						</tr>
					</g:each>

				</tbody>
			</table>
			<div class="pagination">
				<g:paginate total="${categoriaInstanceCount ?: 0}" />
			</div>
		</div>
	</section>



	<footer>Você tem <span id="taskCount">0</span> tarefas</footer>
	</body>

</html>
