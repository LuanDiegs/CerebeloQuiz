extends Control
class_name ResponderQuizTwitch

#Painel principal
@onready var _nomeDoCanalInput = $MarginTela/ItensDaTela/QuizECronometro/PainelPrincipal/ItensMargin/Itens/InputNomeDoCanal
@onready var _iniciarQuizBotao = $MarginTela/ItensDaTela/QuizECronometro/PainelPrincipal/ItensMargin/Itens/BotaoJogar

#Chat
@onready var _containerSrollMensagensChat = $MarginTela/ItensDaTela/ItensLaterais/Chat/ItensChat/ContainerMensagensTwitch
@onready var _scrollcontainerSrollMensagensChat = _containerSrollMensagensChat.get_v_scroll_bar()
@onready var _containerDisplayMensagensChat = $MarginTela/ItensDaTela/ItensLaterais/Chat/ItensChat/ContainerMensagensTwitch/MensagensTwitch
const _temaMensagensChat = preload("res://cenas/responderQuizTwitch/mensagemRichLabelTema.tres")

func _ready():
	_iniciarQuizBotao.connect("pressed", vinculaComATwitch)
	_scrollcontainerSrollMensagensChat.connect("changed", ajustaScrollDoChat)


func vinculaComATwitch():
	var nomeDoCanal: String = _nomeDoCanalInput.text
	
	if !nomeDoCanal:
		print("Erro ao conectar")
		return
		
	if !VerySimpleTwitch._twitch_chat or VerySimpleTwitch._twitch_chat._channel.login != nomeDoCanal:
		var nomeAntigoCanal = VerySimpleTwitch._twitch_chat._channel.login if VerySimpleTwitch._twitch_chat else null
		VerySimpleTwitch.login_chat_anon(nomeDoCanal)
		
		if !VerySimpleTwitch._twitch_chat._hasConnected:
			VerySimpleTwitch.chat_message_received.connect(insereMensagemNoChat)

		if nomeAntigoCanal and nomeAntigoCanal != nomeDoCanal:
			VerySimpleTwitch.change_Channel()
			limpaMensagensDoChat()

		print("Conectado com sucesso ao canal ")


func insereMensagemNoChat(chatter: Chatter):
	var labelAInserir = RichTextLabel.new()
	var mensagem = "[color=#6db066]%s[/color]: %s" % [chatter.tags.display_name, chatter.message]
	
	#Insere as propriedades do label
	labelAInserir.text = mensagem
	labelAInserir.bbcode_enabled = true
	labelAInserir.fit_content = true
	labelAInserir.theme = _temaMensagensChat
	
	#Insere o componente como filho do hbox
	_containerDisplayMensagensChat.add_child(labelAInserir)
	
	#Se tiver mais que 20 mensagens no chat, ele remove as primeiras
	if(_containerDisplayMensagensChat.get_children().size() > 20):
		_containerDisplayMensagensChat.remove_child(_containerDisplayMensagensChat.get_child(0))


func ajustaScrollDoChat():
	_containerSrollMensagensChat.scroll_vertical = _scrollcontainerSrollMensagensChat.max_value


func limpaMensagensDoChat():
	for mensagem in _containerDisplayMensagensChat.get_children():
		_containerDisplayMensagensChat.remove_child(mensagem)
