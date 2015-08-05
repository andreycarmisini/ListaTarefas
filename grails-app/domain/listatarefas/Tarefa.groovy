package listatarefas

class Tarefa {

    String descricao
    Date deadline
    Categoria categoria
    Boolean concluido

    static constraints = {
        descricao nullable:false, blank:false
        deadline nullable:false
        concluido nullable:true
    }
}
