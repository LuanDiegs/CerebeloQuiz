extends Node
class_name Sessao

var isLogada: bool = false
var usuarioIdLogado


func sessaoAtivada(usuarioId):
	isLogada = true
	usuarioIdLogado = usuarioId


func sessaoDesativada():
	isLogada = false
	usuarioIdLogado = null
