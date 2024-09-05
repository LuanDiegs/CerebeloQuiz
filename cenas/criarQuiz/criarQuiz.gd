extends Control
class_name CriarQuiz

const perguntaQuizCardComponente = preload("res://componentes/containerPerguntaCriacaoQuiz/containerPerguntaCriacaoQuiz.tscn")
@onready var adicionarPerguntaBotao: Button = $Perguntas/HeaderPerguntas/Titulo/AdicionarPergunta
@onready var perguntasContainer: VBoxContainer = $Perguntas/PerguntasScrollContainer/PerguntasContainer


func _ready() -> void:
	adicionarPerguntaBotao.connect("pressed", criarPergunta)


func criarPergunta() -> void:
	if(perguntasContainer.get_children().size() < ConstantesPadroes.MAXIMO_PERGUNTAS_QUIZ):
		var perguntaCard = perguntaQuizCardComponente.instantiate()
		perguntasContainer.add_child(perguntaCard)
	else:
		var mensagemMaximoPerguntas = "Um quiz pode ter no máximo " + str(ConstantesPadroes.MAXIMO_PERGUNTAS_QUIZ) + " perguntas"
		PopUp.criaPopupNotificacao(mensagemMaximoPerguntas)
