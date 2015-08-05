package listatarefas

class Categoria {

    String nome

    static constraints = {
        nome nullable:false, blank:false
    }

    @Override
    String toString() {
        return nome
    }

}
