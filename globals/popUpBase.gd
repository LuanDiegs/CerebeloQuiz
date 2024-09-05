extends Panel
class_name PopUpBase


func _ready() -> void:
	self.scale = Vector2(0,0)
	

func criaPopupNotificacao(
	conteudo: String = "Ocorreu um erro inesperado",
	redirecionaPara: String = "",
	titulo: String = "Atenção", 
	textoBotaoFechar: String = "Fechar") -> void:
	
	var componente = preload("res://componentes/popUps/popUpNotificacao/popUpNotificacao.tscn").instantiate()
	
	#Coloca os parametros
	componente.titulo = titulo
	componente.conteudo = conteudo
	componente.textoBotaoFechar = textoBotaoFechar
	componente.redirecionaPara = redirecionaPara
	
	#Cria o componente na tela
	get_tree().root.add_child(componente)
	
	#Anima a entrada do componente
	componente.animaEntrada()


func animaEntradaPadrao():
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2(1,1), 0.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CIRC)
