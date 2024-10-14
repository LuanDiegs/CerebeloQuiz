extends PopUpBase
class_name PopUpFormDenunciaQuiz

@onready var _popUp = $PopUp

@onready var _fecharBotao = $PopUp/ContainerVertical/Titulo/FecharModal
@onready var _salvarBotao = $PopUp/ContainerVertical/MarginRanking/ItensContainer/Salvar

@onready var _nomeDoQuizLabel = $PopUp/ContainerVertical/NomeDoQuiz
@onready var _motivosSelecaoGrid = $PopUp/ContainerVertical/MarginRanking/ItensContainer/SelecaoMotivos/Motivos

@onready var _justificativaInput = $PopUp/ContainerVertical/MarginRanking/ItensContainer/Justificativa/JustificativaTexto
@onready var _erroMotivosLabel = $PopUp/ContainerVertical/MarginRanking/ItensContainer/SelecaoMotivos/ContainerTitulo/ErroMotivos
@onready var _erroJustificativaLabel = $PopUp/ContainerVertical/MarginRanking/ItensContainer/Justificativa/ContainerTitulo/ErroJustificativa

var _quizId: int

func _ready() -> void:
	_fecharBotao.connect("pressed", fechaPopup)
	_salvarBotao.connect("pressed", salvarDenuncia)
	
	#Cria os motivos
	var motivos = MotivoDenuncia.new().getMotivosDenuncia()
	for motivo in motivos:
		var motivoComponente = preload("res://componentes/popUps/popUpFormDenuncia/motivoBotaoSelecao.tscn").instantiate()
	
		_motivosSelecaoGrid.add_child(motivoComponente)
		motivoComponente.inserePropriedadesDoComponente(motivo.id, motivo.descricao)
	

func definePropriedadesDoQuiz(quizId: int, quizTitulo: String):
	_quizId = quizId
	_nomeDoQuizLabel.text = quizTitulo


func animaEntrada():
	_popUp.scale = Vector2(0,0)
	_popUp.pivot_offset.x = _popUp.size.x/2
	_popUp.pivot_offset.y = _popUp.size.y/2
	
	var tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	tween.tween_property(_popUp, "scale", Vector2(0,0), 0.00001)
	tween.tween_property(_popUp, "scale", Vector2(1.15,1.15), 0.3)
	tween.tween_property(_popUp, "scale", Vector2(1,1), 0.2)
	await tween.finished


func fechaPopup():
	var tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	tween.tween_property(_popUp, "scale", Vector2(1.1,1.1), 0.2)
	tween.tween_property(_popUp, "scale", Vector2(0,0), 0.3)
	await tween.finished
	self.queue_free()


func validaFormulario(motivosSelecionados: Array):
	var erro = false
	
	if !_justificativaInput.text:
		_erroJustificativaLabel.text = "O campo de justificativa é obrigatório"
		erro = true
	else: 
		_erroJustificativaLabel.text = ""
		
	if motivosSelecionados.is_empty():
		_erroMotivosLabel.text = "Selecione pelo menos um motivo"
		erro = true
	else: 
		_erroMotivosLabel.text = ""
	
	return !erro
		
func salvarDenuncia():
	var motivosSelecionadosIds: Array
	for motivo in _motivosSelecaoGrid.get_children():
		if motivo is MotivoBotaoSelecao:
			if motivo.button_pressed:
				motivosSelecionadosIds.append(motivo.motivoId)
				
	if !validaFormulario(motivosSelecionadosIds):
		return
	
	var denunciaClasse = Denuncia.new()
	var denunciaAInserir = denunciaClasse.instanciaEntidade(_justificativaInput.text, _quizId, SessaoUsuario.usuarioLogado.idUsuario)
	
	var response = denunciaClasse.salvarDenuncia(denunciaAInserir, motivosSelecionadosIds)
	
	if response:
		self.fechaPopup()
		PopUp.criaPopupNotificacao("Denúncia registrada com sucesso!")


func _on_gui_input(event: InputEvent) -> void:
	if(event.is_action_pressed("CliqueDireito")):
		fechaPopup()
