extends Control
class_name ResponderQuiz

#Node pai
@onready var nodePai: ResponderQuiz = $"."

#Timer
@onready var _tempoPercorrido: Timer = $TempoPercorrido
@onready var _tempoPercorridoLabel: Label = $MarginQuizzes/QuizzesContainer/MarginContainer/QuizContainer/TempoPercorridoLabel
var _segundosPercorridos: int = 0
var _minutosPercorridos: int = 0

#Botoes avançar e retroceder pergunta
@onready var _retrocederPerguntaBotao: Button = $MarginQuizzes/QuizzesContainer/RetrocederPerguntaBotao
@onready var _avancarPerguntaBotao: Button = $MarginQuizzes/QuizzesContainer/AvancarPerguntaBotao
var _insercaoPerguntaTerminou := true

#Container quiz
@onready var _quizContainer: VBoxContainer = $MarginQuizzes/QuizzesContainer/MarginContainer/QuizContainer
var _quizCard: EscolhaAlternativaQuiz = null

#Quiz
var idQuiz: int = 17
var perguntas: Array
var perguntasCardsComponentes: Array
var indexPerguntaAtual := 0


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
	
	#Insere as perguntas na variável e já cria seus componentes
	perguntas = Quizzes.new().getPerguntasEAlternativasDoQuiz(idQuiz)
	await criarComponentesDasPerguntas(perguntas)
	
	_quizContainer.add_child(perguntasCardsComponentes[indexPerguntaAtual])
	_quizCard = perguntasCardsComponentes[indexPerguntaAtual]


func criarComponentesDasPerguntas(perguntas: Array):
	for pergunta in perguntas:
		var quizCardComponente = preload("res://componentes/escolhaAlternativaQuiz/escolhaAlternativaQuiz.tscn").instantiate() as EscolhaAlternativaQuiz
		
		quizCardComponente.perguntaId = pergunta["perguntaId"]
		quizCardComponente.perguntaConteudo = pergunta["conteudoPergunta"]
		quizCardComponente.alternativas = pergunta["alternativas"]
		
		perguntasCardsComponentes.append(quizCardComponente)


func proximaPergunta():
	if(!_insercaoPerguntaTerminou):
		return
	
	_insercaoPerguntaTerminou = false
	indexPerguntaAtual +=1
	var proximaPergunta = perguntasCardsComponentes[indexPerguntaAtual]
	
	await animaEntradaSaida(true)
	
	#Insere a pergunta normal
	_quizCard = proximaPergunta
	_insercaoPerguntaTerminou = true
	_quizContainer.add_child(proximaPergunta)


func perguntaAnterior():
	if(!_insercaoPerguntaTerminou):
		return
	
	_insercaoPerguntaTerminou = false
	indexPerguntaAtual -= 1
	var perguntaAnterior = perguntasCardsComponentes[indexPerguntaAtual]
	
	await animaEntradaSaida(false)
	
	#Insere a pergunta normal
	_quizCard = perguntaAnterior
	_insercaoPerguntaTerminou = true
	_quizContainer.add_child(perguntaAnterior)
	
	

func animaEntradaSaida(isEntradaEsquerda: bool = true):
	#Insere o node 'fantasma' para fazer a animação
	var perguntaAnteriorFantasma = perguntasCardsComponentes[indexPerguntaAtual].duplicate()
	
	#Coloca propriedades para a animação rodar ok
	perguntaAnteriorFantasma.global_position = _quizCard.global_position
	perguntaAnteriorFantasma.isEntradaEsquerda = isEntradaEsquerda
	get_tree().root.add_child(perguntaAnteriorFantasma)
	perguntaAnteriorFantasma.set_deferred("size", _quizCard.size)
	
	#Anima saida pergunta
	_quizCard.isEntradaEsquerda = isEntradaEsquerda
	_quizCard.saidaPergunta()
	
	#Anima entrada e tira o node após terminar a animação
	await perguntaAnteriorFantasma.entradaPergunta(true)


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
