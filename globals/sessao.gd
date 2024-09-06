extends Node
class_name Sessao

var isLogada: bool = false
var usuarioLogado: Usuarios


func sessaoAtivada(usuarioId):
	isLogada = true
	usuarioLogado = Usuarios.new().getUsuario(usuarioId)
	

func sessaoDesativada():
	isLogada = false
	usuarioLogado = null
