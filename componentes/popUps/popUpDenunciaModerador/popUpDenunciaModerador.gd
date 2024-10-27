extends PopUpBase
class_name PopUpDenunciaModerador

@onready var _popUp: Panel = $PopUp
@onready var _fecharSuperior = $PopUp/FecharModal

@onready var _tituloQuizLabel = $PopUp/MarginJustificativas/VboxContainer/Header/TituloQuiz

@onready var _justificativasContainer = $PopUp/MarginJustificativas/VboxContainer/JustificativasScroll/JustificativasContainer

var _quizId: int

func _ready() -> void:
	_fecharSuperior.connect("pressed", fechaPopup)
	
	
func insereInformacoesPrincipais(quizTitulo: String, quizId: int):
	_tituloQuizLabel.text = quizTitulo
	_quizId = quizId
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
