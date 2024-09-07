extends PopUpBase
class_name PopUpFormPergunta

var titulo: String
var conteudoPergunta: String
var textoBotaoFechar: String

@onready var popUp: Panel = $PopUp

@onready var tituloLabel = $PopUp/ContainerVertical/Titulo
@onready var fecharBotao = $PopUp/ContainerVertical/MarginForm/Form/Alternativas/HBoxContainer/Fechar
@onready var salvarBotao = $PopUp/ContainerVertical/MarginForm/Form/Alternativas/HBoxContainer/Salvar

@onready var perguntaConteudoInput := $PopUp/ContainerVertical/MarginForm/Form/PerguntaConteudo as TextEdit

var componenteCardPergunta: ContainerPerguntaQuiz


func _ready() -> void:
	popUp.scale = Vector2(0,0)
	
	fecharBotao.connect("pressed", fechaPopup.bind(false))
	salvarBotao.connect("pressed", fechaPopup.bind(true))
	
	if(componenteCardPergunta != null):
		conteudoPergunta = componenteCardPergunta.conteudoPergunta
		
	tituloLabel.text = titulo
	fecharBotao.text = "Cancelar"
	perguntaConteudoInput.text = conteudoPergunta
	
	
	
func animaEntrada():
	var tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	tween.tween_property(popUp, "scale", Vector2(1.15,1.15), 0.3)
	tween.tween_property(popUp, "scale", Vector2(1,1), 0.2)
	await tween.finished


func fechaPopup(salvar: bool):
	var tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	tween.tween_property(popUp, "scale", Vector2(1.1,1.1), 0.2)
	tween.tween_property(popUp, "scale", Vector2(0,0), 0.3)
	await tween.finished
	
	if(salvar and componenteCardPergunta):
		componenteCardPergunta.conteudoPergunta = perguntaConteudoInput.text
		
	self.queue_free()


func _on_gui_input(event: InputEvent) -> void:
	if(event.is_action_pressed("CliqueDireito")):
		fechaPopup(false)
