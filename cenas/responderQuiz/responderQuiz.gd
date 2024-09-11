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

#Container quiz
@onready var _quizContainer: VBoxContainer = $MarginQuizzes/QuizzesContainer/MarginContainer/QuizContainer
@onready var _quizCard: PanelContainer = $MarginQuizzes/QuizzesContainer/MarginContainer/QuizContainer/QuizzCard as EscolhaAlternativaQuiz


func _ready() -> void:
	_retrocederPerguntaBotao.connect("pressed", perguntaAnterior)
	_avancarPerguntaBotao.connect("pressed", proximaPergunta)
	_tempoPercorrido.connect("timeout", aumentaTimer)


func proximaPergunta():
	var perguntaAnterior = _quizCard.duplicate() as EscolhaAlternativaQuiz
	
	await animaEntradaSaida(true)
	
	#Insere a pergunta normal
	_quizContainer.add_child(perguntaAnterior)
	_quizCard = perguntaAnterior


func perguntaAnterior():
	var perguntaAnterior = _quizCard.duplicate() as EscolhaAlternativaQuiz
	
	await animaEntradaSaida(false)
	
	#Insere a pergunta normal
	_quizContainer.add_child(perguntaAnterior)
	_quizCard = perguntaAnterior
	

func animaEntradaSaida(isEntradaEsquerda: bool = true):
	#Insere o node 'fantasma' para fazer a animação
	var perguntaAnteriorFantasma = _quizCard.duplicate() as EscolhaAlternativaQuiz
	
	#Coloca propriedades para a animação rodar ok
	perguntaAnteriorFantasma.global_position = _quizCard.global_position
	perguntaAnteriorFantasma.isEntradaEsquerda = isEntradaEsquerda
	get_tree().root.add_child(perguntaAnteriorFantasma)
	perguntaAnteriorFantasma.set_deferred("size", _quizCard.size)
	
	#Anima saida pergunta
	_quizCard.isEntradaEsquerda = isEntradaEsquerda
	_quizCard.saidaPergunta()
	
	#Anima entrada e tira o node após terminar a animação
	await perguntaAnteriorFantasma.entradaPergunta()
	perguntaAnteriorFantasma.queue_free()


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
