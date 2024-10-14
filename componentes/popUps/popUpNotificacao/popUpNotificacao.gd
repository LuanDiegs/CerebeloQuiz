extends PopUpBase
class_name PopUpNotificacao

var titulo: String
var conteudo: String
var textoBotaoFechar: String

var redirecionaPara: String

@onready var _popUp: Panel = $PopUp

@onready var _tituloLabel: Label = $PopUp/ContainerVertical/Titulo
@onready var _conteudoLabel: Label = $"PopUp/ContainerVertical/Conteúdo"
@onready var _fecharBotao: Button = $PopUp/ContainerVertical/ContainerBotoes/Fechar
@onready var _containerBotoes = $PopUp/ContainerVertical/ContainerBotoes

var botaoFecharInvisivel: bool = false
var isModalConfirmacao: bool = false

func _ready() -> void:	
	_fecharBotao.connect("pressed", fechaPopup)
	
	_tituloLabel.text = titulo
	_conteudoLabel.text = conteudo
	_fecharBotao.text = textoBotaoFechar
	
	if(botaoFecharInvisivel):
		_fecharBotao.visible = false
	
	
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
	
	#Caso exista essa propriedade após fechar o modal ele será redirecionado para aquela tela diretamente
	#Idependente se tiver ou não confirmação
	if(!redirecionaPara.is_empty()):
		TransicaoCena.trocar_cena(redirecionaPara, 0, 0, true)


func _on_gui_input(event: InputEvent) -> void:
	if(!botaoFecharInvisivel):
		if(event.is_action_pressed("CliqueDireito")):
			fechaPopup()


func inserirBotaoOpcional(textoBotao: String, funcaoBotao: Callable, funcaoAposAcao: Callable = func(): pass):
	var novoBotao = _fecharBotao.duplicate() as Button
	novoBotao.text = textoBotao
	novoBotao.connect(
		"pressed", 
		func(): 
			funcaoBotao.call()
			self.fechaPopup()
			if funcaoAposAcao:
				funcaoAposAcao.call())
	
	_containerBotoes.add_child(novoBotao)
	_containerBotoes.move_child(novoBotao, 0)
