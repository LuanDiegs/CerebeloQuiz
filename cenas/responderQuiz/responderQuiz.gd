extends Control
class_name ResponderQuiz

#Node pai
@onready var nodePai: ResponderQuiz = $"."

#Timer
@onready var _tempoPercorrido: Timer = $TempoPercorrido
@onready var _tempoPercorridoLabel: Label = $ScrollQuizzes/MarginQuizzes/QuizzesContainer/QuizRespostaMargin/QuizContainer/TempoPercorridoLabel
var _segundosPercorridos: int = 0
var _minutosPercorridos: int = 0

#Botoes avançar e retroceder pergunta
@onready var _retrocederPerguntaBotao: Button = $ScrollQuizzes/MarginQuizzes/QuizzesContainer/RetrocederPerguntaBotao
@onready var _avancarPerguntaBotao: Button = $ScrollQuizzes/MarginQuizzes/QuizzesContainer/AvancarPerguntaBotao
var _insercaoPerguntaTerminou := true

#Container quiz
@onready var _quizContainer: VBoxContainer = $ScrollQuizzes/MarginQuizzes/QuizzesContainer/QuizRespostaMargin/QuizContainer
var _quizCard: EscolhaAlternativaQuiz = null

#Quiz
@export var quizId: int = 0
var perguntas: Array
var perguntasCardsComponentes: Array[EscolhaAlternativaQuiz]
var indexPerguntaAtual := 0

#Salvamento
@onready var _salvar: Button = $Salvar

func _process(delta):
	#Verifica se os botões de avançar e retroceder ficarão desabilitados
	if(indexPerguntaAtual+1 == perguntasCardsComponentes.size()):
		_avancarPerguntaBotao.disabled = true
	else:
		_avancarPerguntaBotao.disabled = false
	
	if(indexPerguntaAtual == 0):
		_retrocederPerguntaBotao.disabled = true
	else:
		_retrocederPerguntaBotao.disabled = false


func _ready() -> void:
	_retrocederPerguntaBotao.connect("pressed", perguntaAnterior)
	_avancarPerguntaBotao.connect("pressed", proximaPergunta)
	_tempoPercorrido.connect("timeout", aumentaTimer)
	_salvar.connect("pressed", responderQuiz)
	
	#Insere as perguntas na variável e já cria seus componentes
	perguntas = Quizzes.new().getPerguntasEAlternativasDoQuiz(quizId)
	await criarComponentesDasPerguntas(perguntas)
	
	#Aleatoriza as perguntas
	perguntasCardsComponentes.shuffle()
	
	#Insere a primeira pergunta
	_quizContainer.add_child(perguntasCardsComponentes[indexPerguntaAtual])
	_quizCard = perguntasCardsComponentes[indexPerguntaAtual]
	
	for index in perguntasCardsComponentes.size():
		if index == indexPerguntaAtual:
			continue
		
		_quizContainer.add_child(perguntasCardsComponentes[index])
		_quizContainer.remove_child(perguntasCardsComponentes[index])


func criarComponentesDasPerguntas(perguntas: Array):
	for pergunta in perguntas:
		var quizCardComponente = preload("res://componentes/escolhaAlternativaQuiz/escolhaAlternativaQuiz.tscn").instantiate() as EscolhaAlternativaQuiz
		
		quizCardComponente.perguntaId = pergunta["perguntaId"]
		quizCardComponente.perguntaConteudo = pergunta["conteudoPergunta"]
		quizCardComponente.alternativas = pergunta["alternativas"]
		
		perguntasCardsComponentes.append(quizCardComponente)


func proximaPergunta():
	animaEntradaSaida(true)


func perguntaAnterior():
	animaEntradaSaida(false)


#Sem animação por enquanto
func animaEntradaSaida(isProximaPergunta: bool = true):
	if(!_insercaoPerguntaTerminou):
		return
	
	#Pega o node anterior
	_insercaoPerguntaTerminou = false
	indexPerguntaAtual = indexPerguntaAtual+1 if isProximaPergunta else indexPerguntaAtual-1
	
	#Insere o node no contexto global para fazer a animação
	var perguntaCard = perguntasCardsComponentes[indexPerguntaAtual]

	#Coloca propriedades para a animação rodar ok
	perguntaCard.global_position = _quizCard.global_position
	perguntaCard.isEntradaEsquerda = isProximaPergunta
	
	self.add_child(perguntaCard)
	perguntaCard.set_deferred("size", _quizCard.size)
	
	#Anima saida pergunta
	_quizCard.isEntradaEsquerda = isProximaPergunta
	
	#Remove o node que saiu
	_quizContainer.remove_child(_quizCard)
	
	#Insere o quiz atual como o node criado
	#Remove o quiz do contexto global e insere no container certo
	_quizCard = perguntaCard
	_insercaoPerguntaTerminou = true
	self.remove_child(perguntaCard)
	_quizContainer.add_child(perguntaCard)


func aumentaTimer():
	_segundosPercorridos += 1
	
	if(_segundosPercorridos == 60):
		_minutosPercorridos+=1
		_segundosPercorridos = 0
	
	_tempoPercorridoLabel.text = formataTempo(_minutosPercorridos, _segundosPercorridos)


func formataTempo(minutos: int, segundos: int):
	var minutosFormatado
	var segundosFormatado
	
	if(minutos < 10):
		minutosFormatado = "0" + str(minutos)
	else:
		minutosFormatado = str(minutos)
		
	if(segundos < 10):
		segundosFormatado = "0" + str(segundos)
	else:
		segundosFormatado = str(segundos)
	
	return minutosFormatado + ":" + segundosFormatado


func responderQuiz():
	var alternativas: Array[BotaoEscolherAlternativa]
	var acertos := 0
	var quantidadePerguntasRespondidas := 0
	
	#Pega todas os cards das perguntas
	for cardPergunta in perguntasCardsComponentes:
		var vbox = cardPergunta.get_child(0).get_children()
		
		for alternativa in vbox:
			if(alternativa.is_in_group("alternativasResposta")):
				alternativa = alternativa as BotaoEscolherAlternativa
				quantidadePerguntasRespondidas = quantidadePerguntasRespondidas+1 if alternativa.button_pressed else quantidadePerguntasRespondidas
				acertos = acertos+1 if alternativa.button_pressed and alternativa.isAlternativaCorreta else acertos
	
	#Verifica se ele respondeu todas as perguntas
	if(quantidadePerguntasRespondidas < perguntasCardsComponentes.size()):
		PopUp.criaPopupConfirmacao(
			"Você não respondeu todas as perguntas.\n Quer salvar mesmo assim?",
			"Atenção",
			"Cancelar",
			Utils.criaBotaoAdicional(
				"Confirmar", 
				func(): 
					salvarResultado(acertos)))
		return
	
	salvarResultado(acertos)


func salvarResultado(acertos: int):
	if(SessaoUsuario.isLogada):
		var tempoTotalPercorrido = (_minutosPercorridos*60) + _segundosPercorridos

		var pontuacaoFinal = (acertos*1000)/tempoTotalPercorrido
		var rankingPessoal = RankingPessoal.new().instanciaEntidade(pontuacaoFinal, quizId, SessaoUsuario.usuarioLogado.idUsuario)
		var response = BD.inserirDados(EntidadeConstantes.RankingPessoalTabela, rankingPessoal)
		
		if(response):
			notificaPontuacao(acertos, pontuacaoFinal)
		else:
			PopUp.criaPopupNotificacao(
				"Ocorreu um erro ao computar sua pontuação!", 
				"", 
				"Poxa")
	else:
		notificaPontuacao(acertos)
	
	finalizaQuiz()


func finalizaQuiz():
	#Para o tempo e desabilita ele responder o quiz novamente
	_tempoPercorrido.stop()
	_salvar.visible = false
	exibeRespostasCorretas()
	

func exibeRespostasCorretas():
	for pergunta in perguntasCardsComponentes:
		pergunta.desabilitaEMostraAlternativaCorretaQuiz()


func notificaPontuacao(acertos: int, pontuacao: int = -1):
	var aviso = "\n*Não logado, sua pontuação não estará no ranking" if !SessaoUsuario.isLogada else ""
	var acertosMensagem = "Você acertou " + str(acertos) + "/" + str(perguntasCardsComponentes.size())
	var pontuacaoMensagem = "" if pontuacao < 0 else "\n Sua pontuacao foi de " + str(pontuacao)
	
	PopUp.criaPopupConfirmacao(
		acertosMensagem + aviso + pontuacaoMensagem, 
		"Parabéns!", 
		"Revisar o quiz",
		Utils.criaBotaoAdicional(
			"Ver ranking", 
			func(): PopUp.criaPopupRankingQuiz(quizId)))

	
	
