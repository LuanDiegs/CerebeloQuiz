extends VBoxContainer

@onready var button = $"../../../../../../../Button"
@onready var mensagens_twitch = $"."
@onready var container_mensagens_twitch = $".."
@onready var scroll = container_mensagens_twitch.get_v_scroll_bar()
const MENSAGEM_TEMA = preload("res://cenas/responderQuizTwitch/mensagemTema.tres")


func _ready():
	button.connect("pressed", adicionaMensagem)
	scroll.connect("changed", troca)


func troca():
	container_mensagens_twitch.scroll_vertical = scroll.max_value
	

func adicionaMensagem():
	var nro = randi()
	var label = Label.new()
	label.theme = MENSAGEM_TEMA
	label.text = str(nro)
	
	mensagens_twitch.add_child(label)
	
	if(mensagens_twitch.get_children().size() > 20):
		mensagens_twitch.remove_child(mensagens_twitch.get_child(0))
