tasksController = function() {
	function errorLogger(errorCode, errorMessage) {
		console.log(errorCode +':'+ errorMessage);
	}
	
	//Função criada para chamar as outras funções necessarias para atualização das informações.
	function utils(taskPage){
	
		//Atualiza a cor de fundo 
		$(taskPage).find('tbody tr:even').addClass('even');
		
		//Atualiza o deadline das tarefas
		deadline(taskPage);	
		
		//Verifica estados
		verificaEstado(taskPage);
		
		//Atualiza o contador de tarefas
		countTasks(taskPage);
	
	}
	
	//ITEM 1 - Atualiza o campo (id) taskCount, com o valor de quantidade de tarefas (linhas da tabela)
	function countTasks(taskPage){
		var done = 0 ;
		//Guarda o numero de tarefas completadas
       $(taskPage).find('tbody tr td.not').each(function(){
			if ($(this).text() == 'sim'){
				done++;
			}
       });
		
		//guarda o numero de linhas da tabela
		var tasksTotal = $(taskPage).find('#tblTasks tbody tr').length;


		//atualiza o numero de tarefas
		$('#taskCount').text(tasksTotal-done); 

	}
	
	//ITEM 2 - O codigo está mais abaixo.
	
	
	//ITEM 3 - Destacar tarefas que já passaram do deadline
	function deadline(taskPage){
		
		//Percorre todos os campos "time", pegando as datas onde é feita as comparações
		$(taskPage).find('tbody tr td time').each(function(){
		  	//compara se a data está proxima, o betweewn verifica se a data esta
		  	//dentro do periodo escolhido, nesse caso, utilizei a proximidade de 5 dias.
			if (Date.parse($(this).attr('datetime')).between(Date.today(),Date.today().addDays(5)) == true){
				$(this).parents('tr').addClass('warning');
				
					//Verifica se a data passou da data atual
			}else if (Date.compare(Date.today(), Date.parse($(this).attr('datetime'))) == 1){
				$(this).parents('tr').addClass('overdue');
			}
		});
	}
	
	
	
	//ITEM 4 - Nesta função encontra-se a parte de trata da visualizacao a logica esta mais abaixo tbm no ITEM 4 
	//Para este ITEM 4 foi adicionado uma coluna "td" com class "not" para controle das tarefas que estao ou nao completadas
	function verificaEstado(taskPage){
		
		//Busca todos as "td" com a class "not"
		$(taskPage).find('tbody tr td.not').each(function(){
			if ($(this).text() == 'sim'){
				
				//Adiciona para os 'td' a classe css 'taskCompleted'
                $(this).parents('tr').find("td").eq(0).addClass('taskCompleted');
                $(this).parents('tr').find("td").eq(1).addClass('taskCompleted');
                $(this).parents('tr').find("td").eq(2).addClass('taskCompleted');

				//Esconde os irmaos, no caso os outros botoes
                $(this).parents('tr').find('.editRow').hide();
                $(this).parents('tr').find('.completeRow').hide();
			}
		});
		
	}
	
	
	//ITEM 5 - Exibir as tarefas ordenadas na aplicação
	function ordenacao(taskPage){
		//Seleciona todas das linhas da tabela
		var $rows = $('tbody > tr', $('#tblTasks'));
	    $rows.sort(function (a, b) {
	    	//Guarda a data nas 'var' e faz um parse transformando no tipo 'Date'
	        var data1 = Date.parse($('td time', a).text());
	        var data2 = Date.parse($('td time', b).text());

            if (data1 > data2) {
		        return -1;
		    } else if (data1 == data2) {
		        return 0;
		    } else {
		        return 1;
		    }
	    });
	    //Para cada linha atualiza a tabela
	    $.each($rows, function (index, row) {
	        $('#tblTasks').append(row);
	    });
	}
	
	var taskPage = '#taskPage';
	var initialised = false;
	return {
		//ITEM 6 - Alteração na chamada do init (adicionando o callback)
		init : function(page, callback) { 
			if (initialised) {
				callback()
			} else {
				storageEngine.init(function() {
					storageEngine.initObjectStore('task', function() {}, 
					errorLogger) 
				}, errorLogger);
			
				taskPage = page;
				$(taskPage).find( '[required="required"]' ).prev('label').append( '<span>*</span>').children( 'span').addClass('required');
				$(taskPage).find('tbody tr:even').addClass('even');
				verificaEstado(taskPage);//verificar se tem tarefa completa
				//Atualizar a ordenacao
				ordenacao(taskPage);
				
				//Atualizar as informações
				utils(taskPage);
				
				if ($(taskPage).find('form').valid()){
					$(taskPage).find( '#btnAddTask' ).click( function(evt) {
						evt.preventDefault();
						$(taskPage ).find('#taskCreation' ).removeClass( 'not');
					});
				}
				$(taskPage).find('#tblTasks tbody' ).on('click','tr',(function(evt) {
					$(evt.target).closest('td').siblings( ).andSelf( ).toggleClass( 'rowHighlight');
				}));
				$(taskPage).find('#tblTasks tbody').on('click', '.deleteRow', 
					function(evt) { 					
						//console.log('teste');
						storageEngine.delete('task', $(evt.target).data().taskId, 
                			function() {
                				$(evt.target).parents('tr').remove();
	                			tasksController.loadTasks();
                			}, errorLogger);
					}					
				);
				$(taskPage).find('#saveTask').click(function(evt) {
					evt.preventDefault();
					if ($(taskPage).find('form').valid()) {
						var task = $(taskPage).find('form').toObject();		
						//seta sempre completed 'nao' para os novos
						task.completed = "nao";
						
						storageEngine.save('task', task, function() {
							$(taskPage).find('#tblTasks tbody').empty();
							tasksController.loadTasks();
							$(':input').val('');
							$(taskPage).find('#taskCreation').addClass('not');
						}, errorLogger);
					}
				});
				$(taskPage).find('#tblTasks tbody').on('click', '.editRow', 
					function(evt) { 
						$(taskPage).find('#taskCreation').removeClass('not');
						storageEngine.findById('task', $(evt.target).data().taskId, function(task) {
							$(taskPage).find('form').fromObject(task);
						}, errorLogger);
						
					}
				);
				
				//ITEM 2 - Ao clicar no botão "limpar tarefa" "id=clearTask" é utlizado a função 'trigger' com o parametro 'reset'
				//Limpando assim,  o conteudo do formulario, que foi passado no id "taskForm"
				$(taskPage).find('#clearTask').click(function(evt) {
					$("#taskForm").trigger('reset');
				});
				
				
				//ITEM 4 - Marcar tarefas como completadas (usando strikethrough no texto)
				//Pega o evento de clique no botao que possue a classe 'completeRow'
				//Foi adicionado uma coluna oculta para salvar o estado da tarefa no caso de completada ou nao.
				//Quando clicar no botao completar altera-se o valor default q é 'nao' para 'sim'
				//quando o valor for sim, entao esconde-se os botoes de editar e excluir e salva-se o estado novo (funcao verificaEstado que trata isso)
				$(taskPage).find('#tblTasks tbody').on('click', '.completeRow', 
					function(evt) {
						
						storageEngine.findById('task', $(evt.target).data().taskId, function(task) {
							//alterar o estado para "sim"
                			task.completed = 'sim';

							storageEngine.save('task', task, function() {
	                			$(taskPage).find('#tblTasks tbody').empty();
								tasksController.loadTasks();
								$(':input').val('');
	                		}, errorLogger);
                		}, errorLogger);
					
						//Atualiza as informações
						utils(taskPage);
				});
				initialised = true;
			}
		},
		loadTasks : function() {			
	            storageEngine.findAll('task', function (tasks) {
	            	$(taskPage).find('#tblTasks tbody').empty();
	            	
	                $.each(tasks, function (index, task) {
	                	
	                    $('#taskRow').tmpl(task).appendTo($(taskPage).find('#tblTasks tbody'));
	                    
	                });
	                
	                //verificar se tem tarefa completa
						verificaEstado(taskPage);
						//Atualizar a ordenacao
						ordenacao(taskPage);
						//Atualiza as informações
						utils(taskPage);
	            }, errorLogger);
			}
	}
}();
