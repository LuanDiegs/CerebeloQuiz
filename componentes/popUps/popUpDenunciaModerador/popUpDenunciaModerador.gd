extends PopUpBase
class_name PopUpDenunciaModerador

@onready var _popUp: Panel = $PopUp
@onready var _fecharSuperior = $PopUp/FecharModal

@onready var _tituloQuizLabel = $PopUp/MarginJustificativas/VboxContainer/Header/TituloQuiz

@onready var _justificativasContainer = $PopUp/MarginJustificativas/VboxContainer/JustificativasScroll/JustificativasContainer

@onready var _desativarQuizBotao = $PopUp/MarginJustificativas/VboxContainer/Botoes/DesativarQuiz
@onready var _desativarUsuarioBotao = $PopUp/MarginJustificativas/VboxContainer/Botoes/DesativarUsuario

var _quizId: int
var _usuarioQuizId: int
signal precisaAtualizarGrid

func _ready() -> void:
	_fecharSuperior.connect("pressed", fechaPopup)
	_desativarQuizBotao.connect("pressed", _desativarQuiz)
	_desativarUsuarioBotao.connect("pressed", _desativarUsuario)


func insereInformacoesPrincipais(quizTitulo: String, quizId: int, usuarioQuizId: int):
	_tituloQuizLabel.text = quizTitulo
	_quizId = quizId
	_usuarioQuizId = usuarioQuizId
	criaCardsJustificativas()
	

func criaCardsJustificativas():
	#Cria as justificativas
	var denunciasJustificativas = Denuncia.new().getDenunciasJustificativasDoQuiz(_quizId)
	for justificativa in denunciasJustificativas:
		var cardInstanciado = preload("res://componentes/popUps/popUpDenunciaModerador/cardJustificativa.tscn").instantiate()
		
		_justificativasContainer.add_child(cardInstanciado)
		cardInstanciado.insereInformacoesPrincipais(justificativa.justificativa, justificativa.nome)


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


func _on_gui_input(event: InputEvent) -> void:
	if(event.is_action_pressed("CliqueDireito")):
		fechaPopup()


func _desativarQuiz():
	var popUp = PopUp.criaPopupConfirmacao(
		"Certeza que deseja desativar o quiz?", 
		"Atenção", 
		"Não", 
		Utils.criaBotaoAdicional("Sim", _desativarQuizAlgoritmo))


func _desativarQuizAlgoritmo():
	var response = Quizzes.new().desativarQuiz(_quizId)
	
	if response:
		PopUp.criaPopupNotificacao("Quiz desativado com sucesso!")
		fechaPopup()
		precisaAtualizarGrid.emit()


func _desativarUsuario():
	var popUp = PopUp.criaPopupConfirmacao(
		"Certeza que deseja desativar o usuário?", 
		"Atenção", 
		"Não", 
		Utils.criaBotaoAdicional("Sim", _desativarUsuarioAlgoritmo))


func _desativarUsuarioAlgoritmo():
	var response = Usuarios.new().desativarUsuario(_usuarioQuizId)
	
	if response:
		PopUp.criaPopupNotificacao("Usuário desativado com sucesso!")
		fechaPopup()
		precisaAtualizarGrid.emit()
