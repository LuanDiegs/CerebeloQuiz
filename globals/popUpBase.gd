extends Panel
class_name PopUpBase


func _ready() -> void:
	self.scale = Vector2(0,0)
	

func criaPopupNotificacao(
	conteudo: String = "Ocorreu um erro inesperado",
	redirecionaPara: String = "",
	titulo: String = "Atenção",
	botaoFecharInvisivel: bool = false,
	textoBotaoFechar: String = "Fechar"):
	
	var componente = preload("res://componentes/popUps/popUpNotificacao/popUpNotificacao.tscn").instantiate()
	
	#Coloca os parametros
	componente.titulo = titulo
	componente.conteudo = conteudo
	componente.textoBotaoFechar = textoBotaoFechar
	componente.redirecionaPara = redirecionaPara
	componente.botaoFecharInvisivel = botaoFecharInvisivel
	
	#Cria o componente na tela
	get_tree().root.add_child(componente)
	
	#Anima a entrada do componente
	componente.animaEntrada()
	
	return componente


func criaPopupEditFormPergunta(
	titulo: String = "Atenção",
	perguntaCard: ContainerPerguntaQuiz = null) -> void:
		
	var componente = preload("res://componentes/popUps/popUpFormPergunta/popUpFormPergunta.tscn").instantiate()
	
	#Coloca os parametros
	componente.titulo = titulo
	if(perguntaCard):
		componente.componenteCardPergunta = perguntaCard
	
	#Cria o componente na tela
	get_tree().root.add_child(componente)
	
	#Anima a entrada do componente
	componente.animaEntrada()


func animaEntradaPadrao():
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2(1,1), 0.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CIRC)
