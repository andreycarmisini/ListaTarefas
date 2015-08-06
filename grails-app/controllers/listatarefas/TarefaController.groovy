package listatarefas



import static org.springframework.http.HttpStatus.*
import grails.transaction.Transactional

@Transactional(readOnly = true)
class TarefaController {

    static allowedMethods = [save: "POST", update: "PUT", delete: "DELETE"]


    def index(Integer max) {

        //Contador de tarefas concluidas
        Integer tarefasConcluidas = 0
        Tarefa.getAll().each { obj ->
            if (obj.concluido == true)
                tarefasConcluidas++
        }

        //Ordenação
        params.max = Math.min(max ?: 10, 100)
        params.sort = 'deadline'
        params.order = 'asc'
        respond Tarefa.list(params), model:[tarefaInstanceCount: Tarefa.count(), tarefasConcluidasCount: tarefasConcluidas]
    }

    def show(Tarefa tarefaInstance) {
        respond tarefaInstance
    }

    def create() {
        respond new Tarefa(params)
    }

    @Transactional
    def save(Tarefa tarefaInstance) {
        if (tarefaInstance == null) {
            notFound()
            return
        }

        if (tarefaInstance.hasErrors()) {
            respond tarefaInstance.errors, view:'create'
            return
        }

        tarefaInstance.save flush:true

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.created.message', args: [message(code: 'tarefa.label', default: 'Tarefa'), tarefaInstance.id])
                redirect tarefaInstance
            }
            '*' { respond tarefaInstance, [status: CREATED] }
        }
    }

    def edit(Tarefa tarefaInstance) {
        respond tarefaInstance
    }

    @Transactional
    def update(Tarefa tarefaInstance) {
        if (tarefaInstance == null) {
            notFound()
            return
        }

        if (tarefaInstance.hasErrors()) {
            respond tarefaInstance.errors, view:'edit'
            return
        }

        tarefaInstance.save flush:true

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.updated.message', args: [message(code: 'Tarefa.label', default: 'Tarefa'), tarefaInstance.id])
                redirect tarefaInstance
            }
            '*'{ respond tarefaInstance, [status: OK] }
        }
    }

    @Transactional
    def delete(Tarefa tarefaInstance) {

        if (tarefaInstance == null) {
            notFound()
            return
        }

        tarefaInstance.delete flush:true

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.deleted.message', args: [message(code: 'Tarefa.label', default: 'Tarefa'), tarefaInstance.id])
                redirect action:"index", method:"GET"
            }
            '*'{ render status: NO_CONTENT }
        }
    }

    @Transactional
    def concluir(Tarefa tarefaInstance) {
        if (tarefaInstance == null) {
            notFound()
            return
        }

        tarefaInstance.concluido = true
        tarefaInstance.save flush:true

        request.withFormat {
            form multipartForm {
                flash.message = "Tarefa foi concluída"
                redirect action:"index", method:"GET"
            }
            '*'{ render status: NO_CONTENT }
        }
    }

    protected void notFound() {
        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.not.found.message', args: [message(code: 'tarefa.label', default: 'Tarefa'), params.id])
                redirect action: "index", method: "GET"
            }
            '*'{ render status: NOT_FOUND }
        }
    }
}
