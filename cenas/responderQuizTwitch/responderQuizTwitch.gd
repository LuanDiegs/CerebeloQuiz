extends Control
class_name ResponderQuizTwitch

#region Variáveis
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
@export var quizId: int = 0
var _perguntas: Array
var _perguntasCardsComponentes: Array[EscolhaAlternativaQuiz]
var _indexPerguntaAtual := 0
var _codigoAlternativaCorretaPerguntaAtual: String
var _podeResponder: bool = false
@onready var _containerAlternativasStreamer := $MarginTela/ItensDaTela/ItensLaterais/StreamerResponderQuizECamera as ContainerCameraStreamerTwitch
@onready var _perguntaContainer = $MarginTela/ItensDaTela/QuizECronometro/PainelPrincipal/ItensTituloMargin/PerguntaContainer

#Placar
var _listaPontuacao: Dictionary
var _listaUsuariosJaResponderam: Dictionary
var _isShowingPergunta: bool = false
var _nomeStreamer: String = ""
@onready var _itensPlacar = $MarginTela/ItensDaTela/ItensLaterais/Placar/ItensPlacar
@onready var _resultadosPainelMaior := $MarginTela/ItensDaTela/QuizECronometro/PainelPrincipal/ItensTituloMargin/PerguntaContainer/Resultados

#Cronometro 
@onready var _separadorCronometro = $MarginTela/ItensDaTela/QuizECronometro/Separador
@onready var _cronometro = $MarginTela/ItensDaTela/QuizECronometro/Cronometro
@onready var _cronometroLabel = $MarginTela/ItensDaTela/QuizECronometro/Cronometro/CronometroContainer/TituloECronometro/Cronometro
@onready var _cronometroTimer = $MarginTela/ItensDaTela/QuizECronometro/Cronometro/Cronometro
@onready var _progressoDoTempo = $MarginTela/ItensDaTela/QuizECronometro/Cronometro/CronometroContainer/ProgressoDoTempo
var tempoLimite := TEMPO_LIMITE_PERGUNTA
var tempoPassado := 1

#Sair da sessão
@onready var _sairSessaoBotao = $MarginTela/ItensDaTela/ItensLaterais/SairSessaoBotao

#endregion

#Constantes
const TEMPO_LIMITE_PERGUNTA = 20
const TEMPO_LIMITE_RESULTADOS = 10
const QUANTIDADE_DE_USUARIOS_PARA_MOSTRAR_NA_TELA = 20


func _ready():
	_iniciarQuizBotao.connect("pressed", iniciarQuiz)
	_scrollcontainerSrollMensagensChat.connect("changed", ajustaScrollDoChat)
	_containerAlternativasStreamer.connect("selecionouAlternativa", calculaPontuacaoStreamer)
	
	#Pega os quiz e suas perguntas
	_perguntas = Quizzes.new().getPerguntasEAlternativasDoQuiz(quizId)
	criarComponentesDasPerguntas(_perguntas)
	
	#Conecta o cronometro
	_cronometroTimer.connect("timeout", handleCronometro)
	
	#Insere o valor máximo do tempo aqui
	_progressoDoTempo.max_value = TEMPO_LIMITE_PERGUNTA
	
	#Foca no input
	_nomeDoCanalInput.grab_focus()
	
	#Sair da sessão botao
	_sairSessaoBotao.connect("pressed", sairSessaoClicked)


func sairSessaoClicked():
	PopUp.criaPopupConfirmacao("Deseja sair da sessão?", 
		"Sair da sessão",
		"Cancelar",
		{
			"textoBotao": "Confirmar", 
			"funcaoBotao": 
				func(): await TransicaoCena.trocar_cena(TransicaoDeCena.telaQuizzesPopulares)})


#Tá repetido mas que se foda
func criarComponentesDasPerguntas(perguntas: Array):
	for pergunta in perguntas:
		var quizCardComponente = preload("res://componentes/escolhaAlternativaQuiz/escolhaAlternativaQuizTwitch.tscn").instantiate() as EscolhaAlternativaQuiz
		
		quizCardComponente.perguntaId = pergunta["perguntaId"]
		quizCardComponente.perguntaConteudo = pergunta["conteudoPergunta"]
		quizCardComponente.alternativas = pergunta["alternativas"]
		quizCardComponente.isTwitchQuiz = true
				
		_perguntasCardsComponentes.append(quizCardComponente)


#region Integração com a Twitch e responses
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
	VerySimpleTwitch.change_channel()
	VerySimpleTwitch._twitch_chat.OnSucess.connect(vinculadoComATwitchComSucesso)
	VerySimpleTwitch._twitch_chat.OnFailure.connect(vinculadoComATwitchComErro)
	
	modalCarregando = PopUp.criaPopupNotificacao(
		"Tentando conectar ao canal " + nomeDoCanal, 
		"",
		"Conectando...",
		true)


func vinculadoComATwitchComSucesso():
	_nomeStreamer = VerySimpleTwitch._twitch_chat._channel.login
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
	
	#Insere a primeira pergunta e coloca as alternativas no container lateral
	insereProximaPergunta()
	_containerAlternativasStreamer.trocarConteudoContainer(_perguntasCardsComponentes[_indexPerguntaAtual].alternativas, true)
	
	#Inicia o cronometro da pergunta
	_cronometroTimer.start()
	_cronometroLabel.text = str(tempoLimite) + ":00"


func vinculadoComATwitchComErro():
	modalCarregando.fechaPopup()
	
	_labelAvisoNomeDoCanalInput.visible = true
	_labelAvisoNomeDoCanalInput.add_theme_color_override("font_color", Color.FIREBRICK)
	_labelAvisoNomeDoCanalInput.text = "Ocorreu um erro ao conectar com a Twitch. Verifique sua conexão ou se o canal está certo."


func pegaMensagem(chatter: Chatter):
	insereMensagemNoChat(chatter)
	calculaPontuacaoUsuario(chatter)
#endregion


#region Perguntas e resultados tela
func insereResultadoNaTela(isResultadoFinal: bool = false):
	#Ordena o placar e insere dentro da tela
	ordenaEInserePontuacaoNoPlacar(isResultadoFinal)
	
	#Remove a antiga pergunta
	if _indexPerguntaAtual > 0 and _perguntaContainer.get_child(_perguntasCardsComponentes[_indexPerguntaAtual-1].get_index()):
		_perguntaContainer.remove_child(_perguntasCardsComponentes[_indexPerguntaAtual-1])
	
	#Insere o painel como visível
	_resultadosPainelMaior.visible = true
	
	#Inicia o cronometro se não for o final da partida
	if !isResultadoFinal:
		_cronometroTimer.start()
		_isShowingPergunta = false


func insereProximaPergunta():
	_resultadosPainelMaior.visible = false
	_isShowingPergunta = true
	_podeResponder = true
	
	#Limpa is usuários que já responderam para responder a nova pergunta
	_listaUsuariosJaResponderam.clear()
	
	#Adiciona a pergunta na tela
	_perguntaContainer.add_child(_perguntasCardsComponentes[_indexPerguntaAtual])
	_codigoAlternativaCorretaPerguntaAtual = _perguntasCardsComponentes[_indexPerguntaAtual].codigoAlternativaCorreta


func mostraRespostaCorreta():
	#Não podem mais responder
	_podeResponder = false
	
	var tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	var nodeAlternativaCorreta = _perguntasCardsComponentes[_indexPerguntaAtual].getAlternativaCorreta()
	
	nodeAlternativaCorreta.alteraOffsetPivotCentroComponente()
	nodeAlternativaCorreta.button_pressed = true
	tween.tween_property(nodeAlternativaCorreta, "scale", Vector2(0.95, 0.95), 0.3)
	tween.tween_property(nodeAlternativaCorreta, "scale", Vector2(1.1, 1.1), 0.5)
	tween.tween_property(nodeAlternativaCorreta, "scale", Vector2(1.1, 1.1), 1.5)
	await tween.finished
	
	#Passa para a próxima pergunta
	_indexPerguntaAtual+=1


func ordenaEInserePontuacaoNoPlacar(isResultadoFinal: bool = false):
	var vintePrimeirosColocados: Dictionary
	var quantidadeDeUsuariosQueResponderam = _listaPontuacao.size() if _listaPontuacao.size() < QUANTIDADE_DE_USUARIOS_PARA_MOSTRAR_NA_TELA else QUANTIDADE_DE_USUARIOS_PARA_MOSTRAR_NA_TELA
	
	#Ordena
	var usuariosQuePontuaram = _listaPontuacao.keys()
	usuariosQuePontuaram.sort_custom(func(a, b):
		return _listaPontuacao[b] < _listaPontuacao[a])
	
	for i in range(quantidadeDeUsuariosQueResponderam):
		vintePrimeirosColocados.get_or_add(i, {"nickname": usuariosQuePontuaram[i], "pontuacao": _listaPontuacao[usuariosQuePontuaram[i]] })
	
	#Coloca o placar no placar lateral
	var itensPlacar = getItensPlacarLatera() as Array[PlacarLateralTwitch]
	for i in range(itensPlacar.size()):
		if vintePrimeirosColocados.get(i):
			itensPlacar[i].inserePlacar(i+1, vintePrimeirosColocados[i]["nickname"], vintePrimeirosColocados[i]["pontuacao"])
	
	#Coloca o placar
	_resultadosPainelMaior.insereDadosNoPainelResultados(vintePrimeirosColocados, isResultadoFinal)
#endregion


#region Cronometro
#Evento que será disparado a cada segundo
func handleCronometro():
	var tempoRestante = tempoLimite - tempoPassado
	
	tempoPassado+=1
	if tempoRestante >= 0:
		_progressoDoTempo.value+=1
		_cronometroLabel.text = ("0" if tempoRestante < 10 else "") + str(tempoRestante) + ":00"
	
	if tempoRestante <= (-2 if _isShowingPergunta else -1):
		_cronometroTimer.stop()
		
		if _isShowingPergunta:
			await mostraRespostaCorreta()

		if(_indexPerguntaAtual < _perguntasCardsComponentes.size()):
			if _isShowingPergunta:
				insereResultadoNaTela()
			else:
				_resultadosPainelMaior.isResultadoVisível = false
				insereProximaPergunta()
			
			#Altera o container da camera e das alternativas
			_containerAlternativasStreamer.trocarConteudoContainer(_perguntasCardsComponentes[_indexPerguntaAtual].alternativas, _isShowingPergunta)
		else:
			insereResultadoNaTela(true) #isFinal
			return
			
		resetarCronometro()


#Reseta o cronometro para outra pergunta
func resetarCronometro():
	var tempoParaTrocarTela = TEMPO_LIMITE_RESULTADOS if !_isShowingPergunta else TEMPO_LIMITE_PERGUNTA
	
	tempoPassado = 1
	_progressoDoTempo.max_value = tempoParaTrocarTela
	_progressoDoTempo.value = 0
	tempoLimite = tempoParaTrocarTela
	
	#Inicia o cronometro da pergunta
	_cronometroTimer.start()
	_cronometroLabel.text = str(tempoParaTrocarTela) + ":00"
#endregion


#region Pontuacao e resultados
func calculaPontuacaoUsuario(chatter: Chatter):
	var nicknameUsuario = chatter.tags.display_name
	
	#Pega a mensagem caso ela comece com ! que é o começo das alternativas
	if _podeResponder and chatter.message[0] == "!":
		if chatter.message == _codigoAlternativaCorretaPerguntaAtual and !_listaUsuariosJaResponderam.get(nicknameUsuario):			
			#Se existir o usuário ele coloca a pontuacao	
			if _listaPontuacao.get(nicknameUsuario):
				_listaPontuacao[nicknameUsuario] += 1000/(tempoPassado-1)
				
			_listaPontuacao.get_or_add(nicknameUsuario, 1000/(tempoPassado-1))
		
		#DEBUG
		_listaPontuacao.get_or_add("nicknameUsuarioTeste"+str(randi_range(0, 50)), 10*randi_range(0, 30))
		
		#O usuário respondeu, independente se acertou ou errou
		_listaUsuariosJaResponderam.get_or_add(nicknameUsuario, true)


func calculaPontuacaoStreamer(acertou: bool):
	if _podeResponder and acertou:
		if _listaPontuacao.get(_nomeStreamer):
			_listaPontuacao[_nomeStreamer] += 1000/(tempoPassado-1)
			
		_listaPontuacao.get_or_add(_nomeStreamer, 1000/(tempoPassado-1))
			
	#O streamer respondeu, independente se acertou ou errou
	_listaUsuariosJaResponderam.get_or_add(_nomeStreamer, true)
#endregion


#region Placar
func getItensPlacarLatera() -> Array[PlacarLateralTwitch]:
	var itensPlacarLateral: Array[PlacarLateralTwitch]
	
	for item in _itensPlacar.get_children():
		if item.is_in_group("placarMinimalistaIntegracaoTwitch"):
			itensPlacarLateral.append(item)
	
	return itensPlacarLateral
#endregion
	
	
#region Chat
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
#endregion
