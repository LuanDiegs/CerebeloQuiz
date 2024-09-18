extends Control
class_name ResponderQuizTwitch

#Painel principal
@onready var _itensTituloMargin = $MarginTela/ItensDaTela/QuizECronometro/PainelPrincipal/ItensTituloMargin
@onready var _nomeDoCanalInput = $MarginTela/ItensDaTela/QuizECronometro/PainelPrincipal/ItensTituloMargin/ItensTitulo/InputNomeDoCanal
@onready var _iniciarQuizBotao = $MarginTela/ItensDaTela/QuizECronometro/PainelPrincipal/ItensTituloMargin/ItensTitulo/BotaoJogar
@onready var _labelAvisoNomeDoCanalInput = $MarginTela/ItensDaTela/QuizECronometro/PainelPrincipal/ItensTituloMargin/ItensTitulo/LabelMensagemTwitch

#Twitch
var modalCarregando: PopUpNotificacao 

#Chat
@onready var _containerSrollMensagensChat = $MarginTela/ItensDaTela/ItensLaterais/Chat/ItensChat/ContainerMensagensTwitch
@onready var _scrollcontainerSrollMensagensChat = _containerSrollMensagensChat.get_v_scroll_bar()
@onready var _containerDisplayMensagensChat = $MarginTela/ItensDaTela/ItensLaterais/Chat/ItensChat/ContainerMensagensTwitch/MensagensTwitch
const _temaMensagensChat = preload("res://cenas/responderQuizTwitch/mensagemRichLabelTema.tres")

#Quiz e perguntas
const _quizId: int = 2
var _perguntas: Array
var _perguntasCardsComponentes: Array[EscolhaAlternativaQuiz]
var _indexPerguntaAtual := 0
var _codigoAlternativaCorretaPerguntaAtual: String
var _listaPontuacao: Dictionary
@onready var _perguntaContainer = $MarginTela/ItensDaTela/QuizECronometro/PainelPrincipal/ItensTituloMargin/PerguntaContainer
@onready var pontuacao: PanelContainer = $MarginTela/ItensDaTela/QuizECronometro/PainelPrincipal/ItensTituloMargin/PerguntaContainer/Pontuacao

#Cronometro 
@onready var _separadorCronometro = $MarginTela/ItensDaTela/QuizECronometro/Separador
@onready var _cronometro = $MarginTela/ItensDaTela/QuizECronometro/Cronometro
@onready var _cronometroLabel = $MarginTela/ItensDaTela/QuizECronometro/Cronometro/CronometroContainer/TituloECronometro/Cronometro
@onready var _cronometroTimer = $MarginTela/ItensDaTela/QuizECronometro/Cronometro/Cronometro
@onready var _progressoDoTempo = $MarginTela/ItensDaTela/QuizECronometro/Cronometro/CronometroContainer/ProgressoDoTempo
var tempoLimite := TEMPO_LIMITE_PERGUNTA
var tempoPassado := 1

#Constantes
const TEMPO_LIMITE_PERGUNTA = 30
const TEMPO_LIMITE_RESULTADOS = 10


func _ready():
	_iniciarQuizBotao.connect("pressed", iniciarQuiz)
	_scrollcontainerSrollMensagensChat.connect("changed", ajustaScrollDoChat)
	
	#Pega os quiz e suas perguntas
	_perguntas = Quizzes.new().getPerguntasEAlternativasDoQuiz(_quizId)
	criarComponentesDasPerguntas(_perguntas)
	
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
				
		_perguntasCardsComponentes.append(quizCardComponente)


#Ação de clicar no iniciar quiz
func iniciarQuiz():
	tentaVincularComATwitch()


func tentaVincularComATwitch():
	var nomeDoCanal: String = _nomeDoCanalInput.text
	
	if !nomeDoCanal:
		_labelAvisoNomeDoCanalInput.visible = true
		_labelAvisoNomeDoCanalInput.add_theme_color_override("font_color", Color.FIREBRICK)
		_labelAvisoNomeDoCanalInput.text = "Insira o nome de um canal!"
		
		return
		
	VerySimpleTwitch.login_chat_anon(nomeDoCanal)
	VerySimpleTwitch._twitch_chat.OnSucess.connect(vinculadoComATwitchComSucesso)
	VerySimpleTwitch._twitch_chat.OnFailure.connect(vinculadoComATwitchComErro)
	
	modalCarregando = PopUp.criaPopupNotificacao(
		"Tentando conectar ao canal " + nomeDoCanal, 
		"",
		"Conectando...",
		true)


func vinculadoComATwitchComSucesso():
	if(modalCarregando):
		await modalCarregando.fechaPopup()
	
	VerySimpleTwitch.chat_message_received.connect(pegaMensagem)
	limpaMensagensDoChat()
		
	# Deixa visível ou invisivel os componentes
	_separadorCronometro.visible = true
	_cronometro.visible = true
	_itensTituloMargin.remove_child(_itensTituloMargin.get_child(0))
	
	#Insere a pergunta na tela
	_perguntaContainer.visible = true
	
	#Insere a primeira pergunta
	insereProximaPergunta()
	
	#Inicia o cronometro da pergunta
	_cronometroTimer.start()
	_cronometroLabel.text = str(tempoLimite) + ":00"


func vinculadoComATwitchComErro():
	modalCarregando.fechaPopup()
	
	_labelAvisoNomeDoCanalInput.visible = true
	_labelAvisoNomeDoCanalInput.add_theme_color_override("font_color", Color.FIREBRICK)
	_labelAvisoNomeDoCanalInput.text = "Ocorreu um erro ao conectar com a Twitch. Verifique sua conexão ou se o canal está certo."


func insereResultadoNaTela():
	#Remove a antiga pergunta
	if _indexPerguntaAtual > 0 and _perguntaContainer.get_child(_perguntasCardsComponentes[_indexPerguntaAtual-1].get_index()):
		_perguntaContainer.remove_child(_perguntasCardsComponentes[_indexPerguntaAtual-1])
	
	#Insere o painel como visível
	pontuacao.visible = true
	
	#Inicia o cronometro da pergunta
	_cronometroTimer.start()


func insereProximaPergunta():
	pontuacao.visible = false

	_perguntaContainer.add_child(_perguntasCardsComponentes[_indexPerguntaAtual])
	_codigoAlternativaCorretaPerguntaAtual = _perguntasCardsComponentes[_indexPerguntaAtual].codigoAlternativaCorreta
	_indexPerguntaAtual+=1


#Evento que será disparado a cada segundo
func handleCronometro():
	var tempoRestante = tempoLimite - tempoPassado
	
	tempoPassado+=1
	if tempoRestante >= 0:
		_progressoDoTempo.value+=1
		_cronometroLabel.text = ("0" if tempoRestante < 10 else "") + str(tempoRestante) + ":00"
	
	if tempoRestante <= (-3 if tempoLimite == TEMPO_LIMITE_PERGUNTA else -1):
		_cronometroTimer.stop()
		
		if(_indexPerguntaAtual < _perguntasCardsComponentes.size()):
			if tempoLimite == TEMPO_LIMITE_PERGUNTA:
				insereResultadoNaTela()
			elif tempoLimite == TEMPO_LIMITE_RESULTADOS:
				insereProximaPergunta()
		else:
			#TODO: Mostrar a tela final
			print("acabou")
			return
			
		resetarCronometro()


#Reseta o cronometro para outra pergunta
func resetarCronometro():
	var tempoParaTrocarTela = TEMPO_LIMITE_RESULTADOS if tempoLimite == TEMPO_LIMITE_PERGUNTA else TEMPO_LIMITE_PERGUNTA
	
	tempoPassado = 1
	_progressoDoTempo.max_value = tempoParaTrocarTela
	_progressoDoTempo.value = 0
	tempoLimite = tempoParaTrocarTela
	
	#Inicia o cronometro da pergunta
	_cronometroTimer.start()
	_cronometroLabel.text = str(tempoParaTrocarTela) + ":00"


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
