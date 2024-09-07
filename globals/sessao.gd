extends Node
class_name Sessao

var isLogada: bool = false
var usuarioLogado: Usuarios


func _ready():
	#APENAS PARA DEBUG, COMENTAR QUANDO FOR MOSTRAR O PRODUTO
	sessaoAtivada(11)


func sessaoAtivada(usuarioId):
	isLogada = true
	usuarioLogado = Usuarios.new().getUsuario(usuarioId)
	

func sessaoDesativada():
	isLogada = false
	usuarioLogado = null
	
