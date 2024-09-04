extends PopUpBase
class_name PopUpNotificacao

var titulo: String
var conteudo: String
var textoBotaoFechar: String

var redirecionaPara: String

@onready var popUp: Panel = $PopUp

@onready var tituloLabel: Label = $PopUp/ContainerVertical/Titulo
@onready var conteudoLabel: Label = $"PopUp/ContainerVertical/Conteúdo"
@onready var fecharBotao: Button = $PopUp/ContainerVertical/Fechar


func _ready() -> void:
	popUp.scale = Vector2(0,0)
	
	fecharBotao.connect("pressed", fechaPopup)
	
	tituloLabel.text = titulo
	conteudoLabel.text = conteudo
	fecharBotao.text = textoBotaoFechar
	
	
func animaEntrada():
	var tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	tween.tween_property(popUp, "scale", Vector2(1.15,1.15), 0.3)
	tween.tween_property(popUp, "scale", Vector2(1,1), 0.2)
	await tween.finished


func fechaPopup():
	var tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	tween.tween_property(popUp, "scale", Vector2(1.1,1.1), 0.2)
	tween.tween_property(popUp, "scale", Vector2(0,0), 0.3)
	await tween.finished
	
	self.queue_free()
	
	#Caso exista essa propriedade após fechar o modal ele será redirecionado para aquela tela
	if(!redirecionaPara.is_empty()):
		TransicaoCena.trocar_cena(redirecionaPara)


func _on_gui_input(event: InputEvent) -> void:
	if(event.is_action_pressed("CliqueDireito")):
		fechaPopup()
