extends Control
class_name ResponderQuizTwitch

#Painel principal
@onready var _itensTituloMargin = $MarginTela/ItensDaTela/QuizECronometro/PainelPrincipal/ItensTituloMargin
@onready var _nomeDoCanalInput = $MarginTela/ItensDaTela/QuizECronometro/PainelPrincipal/ItensTituloMargin/ItensTitulo/InputNomeDoCanal
@onready var _iniciarQuizBotao = $MarginTela/ItensDaTela/QuizECronometro/PainelPrincipal/ItensTituloMargin/ItensTitulo/BotaoJogar
@onready var _labelAvisoNomeDoCanalInput = $MarginTela/ItensDaTela/QuizECronometro/PainelPrincipal/ItensTituloMargin/ItensTitulo/LabelMensagemTwitch

#Chat
@onready var _containerSrollMensagensChat = $MarginTela/ItensDaTela/ItensLaterais/Chat/ItensChat/ContainerMensagensTwitch
@onready var _scrollcontainerSrollMensagensChat = _containerSrollMensagensChat.get_v_scroll_bar()
@onready var _containerDisplayMensagensChat = $MarginTela/ItensDaTela/ItensLaterais/Chat/ItensChat/ContainerMensagensTwitch/MensagensTwitch
const _temaMensagensChat = preload("res://cenas/responderQuizTwitch/mensagemRichLabelTema.tres")

#Quiz
const quizId: int = 2
var perguntas: Array
var perguntasCardsComponentes: Array[EscolhaAlternativaQuiz]
var indexPerguntaAtual := 0
@onready var _perguntaContainer = $MarginTela/ItensDaTela/QuizECronometro/PainelPrincipal/ItensTituloMargin/PerguntaContainer

#Cronometro 
@onready var _separadorCronometro = $MarginTela/ItensDaTela/QuizECronometro/Separador
@onready var _cronometro = $MarginTela/ItensDaTela/QuizECronometro/Cronometro
@onready var _cronometroLabel = $MarginTela/ItensDaTela/QuizECronometro/Cronometro/CronometroContainer/TituloECronometro/Cronometro
@onready var _cronometroTimer = $MarginTela/ItensDaTela/QuizECronometro/Cronometro/Cronometro
@onready var _progressoDoTempo = $MarginTela/ItensDaTela/QuizECronometro/Cronometro/CronometroContainer/ProgressoDoTempo
var tempoLimite := 30
var tempoPassado := 1


func _ready():
	_iniciarQuizBotao.connect("pressed", iniciarQuiz)
	_scrollcontainerSrollMensagensChat.connect("changed", ajustaScrollDoChat)
	
	#Pega os quiz e suas perguntas
	perguntas = Quizzes.new().getPerguntasEAlternativasDoQuiz(quizId)
	criarComponentesDasPerguntas(perguntas)
	
	#Conecta o cronometro
	_cronometroTimer.connect("timeout", handleCronometro)


#Tá repetido mas que se foda
func criarComponentesDasPerguntas(perguntas: Array):
	for pergunta in perguntas:
		var quizCardComponente = preload("res://componentes/escolhaAlternativaQuiz/escolhaAlternativaQuiz.tscn").instantiate() as EscolhaAlternativaQuiz
		
		quizCardComponente.perguntaId = pergunta["perguntaId"]
		quizCardComponente.perguntaConteudo = pergunta["conteudoPergunta"]
		quizCardComponente.alternativas = pergunta["alternativas"]
		quizCardComponente.isTwitchQuiz = true
		
		perguntasCardsComponentes.append(quizCardComponente)


#Ação de clicar no iniciar quiz
func iniciarQuiz():
	if vinculaComATwitch():
		#Deixa visível ou invisivel os componentes
		_separadorCronometro.visible = true
		_cronometro.visible = true
		_itensTituloMargin.remove_child(_itensTituloMargin.get_child(0))
		
		#Insere a pergunta na tela
		_perguntaContainer.visible = true
		_perguntaContainer.add_child(perguntasCardsComponentes[0])
		
		#Inicia o cronometroDaPergunta
		_cronometroTimer.start()
		_cronometroLabel.text = str(tempoLimite) + ":00"


#Evento que será disparado a cada segundo
func handleCronometro():
	var tempoRestante = tempoLimite - tempoPassado
	
	tempoPassado+=1
	_progressoDoTempo.value+=1
	_cronometroLabel.text = ("0" if tempoRestante < 10 else "") + str(tempoRestante) + ":00"
	
	if tempoRestante == 0:
		_cronometroTimer.stop()
		resetarCronometro()
		return


#Reseta o cronometro para outra pergunta
func resetarCronometro():
	tempoPassado = 1
	_cronometroLabel.text = "00:00"
	_progressoDoTempo.value = 0


func vinculaComATwitch():
	var nomeDoCanal: String = _nomeDoCanalInput.text
	
	if !nomeDoCanal:
		_labelAvisoNomeDoCanalInput.visible = true
		_labelAvisoNomeDoCanalInput.add_theme_color_override("font_color", Color.FIREBRICK)
		_labelAvisoNomeDoCanalInput.text = "Insira o nome de um canal!"
		return false
		
	if !VerySimpleTwitch._twitch_chat or VerySimpleTwitch._twitch_chat._channel.login != nomeDoCanal:
		var nomeAntigoCanal = VerySimpleTwitch._twitch_chat._channel.login if VerySimpleTwitch._twitch_chat else null
		VerySimpleTwitch.login_chat_anon(nomeDoCanal)
		
		if !VerySimpleTwitch._twitch_chat._hasConnected:
			VerySimpleTwitch.chat_message_received.connect(pegaMensagem)

		if nomeAntigoCanal and nomeAntigoCanal != nomeDoCanal:
			VerySimpleTwitch.change_Channel()
			limpaMensagensDoChat()
		
		_labelAvisoNomeDoCanalInput.visible = true
		_labelAvisoNomeDoCanalInput.add_theme_color_override("font_color", Color.WEB_GREEN)
		_labelAvisoNomeDoCanalInput.text = "Conectado com sucesso!"
		
	return true


func pegaMensagem(chatter: Chatter):
	insereMensagemNoChat(chatter)


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
