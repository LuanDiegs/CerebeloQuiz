extends PanelContainer
class_name PopUpBase


func _ready() -> void:
	self.scale = Vector2(0,0)
	

func criaPopupNotificacao(
	conteudo: String = "Ocorreu um erro inesperado",
	redirecionaPara: String = "",
	titulo: String = "Atenção",
	botaoFecharInvisivel: bool = false,
	textoBotaoFechar: String = "Fechar") -> PopUpNotificacao:
	
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


func criaPopupConfirmacao(
	conteudo: String = "Ocorreu um erro inesperado",
	titulo: String = "Atenção",
	textoBotaoFechar: String = "Fechar",
	botaoAdicional: Dictionary = {"textoBotao": "", "funcaoBotao": func(): pass, "funcaoAposAcao": func(): pass}):
	
	var popup = criaPopupNotificacao(conteudo, "", titulo, false, textoBotaoFechar)
	
	if(!botaoAdicional.has("funcaoAposAcao")):
		botaoAdicional.get_or_add("funcaoAposAcao", func(): pass)

	popup.inserirBotaoOpcional(botaoAdicional.textoBotao, botaoAdicional.funcaoBotao, botaoAdicional.funcaoAposAcao)


func criaPopupEditFormPergunta(
	titulo: String = "Atenção",
	perguntaCard: ContainerPerguntaQuiz = null) -> void:
		
	var componente = preload("res://componentes/popUps/popUpFormPergunta/popUpFormPergunta.tscn").instantiate()
	
	#Coloca os parametros
	componente.titulo = titulo
	if(perguntaCard):
		componente.componenteCardPergunta = perguntaCard
		componente.idPergunta = perguntaCard.idPergunta
	
	#Cria o componente na tela
	get_tree().root.add_child(componente)
	
	#Anima a entrada do componente
	componente.animaEntrada()


func criaPopupRankingQuiz(quizId: int) -> void:
	var componente = preload("res://componentes/popUps/popUpRankingQuiz/popUpRankingQuiz.tscn").instantiate()
	componente.quizId = quizId
	
	#Cria o componente na tela
	get_tree().root.add_child(componente)
	
	#Anima a entrada do componente
	componente.animaEntrada()


func criaPopupDenunciaQuiz(quizId: int, quizTitulo: String) -> void:
	var componente = preload("res://componentes/popUps/popUpFormDenuncia/popUpFormDenuncia.tscn").instantiate()
	
	#Cria o componente na tela
	get_tree().root.add_child(componente)
	
	#Anima a entrada do componente e insere as propriedades
	componente.definePropriedadesDoQuiz(quizId, quizTitulo)
	componente.animaEntrada()


func criaPopupDenunciaModerador(quizId: int, usuarioQuizId: int, quizTitulo: String) -> PopUpDenunciaModerador:
	var componente = preload("res://componentes/popUps/popUpDenunciaModerador/popUpDenunciaModerador.tscn").instantiate()
	
	#Cria o componente na tela
	get_tree().root.add_child(componente)
	
	#Anima a entrada do componente
	componente.animaEntrada()
	componente.insereInformacoesPrincipais(quizTitulo, quizId, usuarioQuizId)
	
	return componente


func animaEntradaPadrao():
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2(1,1), 0.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CIRC)
