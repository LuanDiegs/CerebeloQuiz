extends Control
class_name MeusQuizzes

var quizzes: Array

@onready var _meusQuizzesContainer = $MarginContainer/ItensTela/ScrollContainer/MeusQuizzesContainer
@onready var _labelMensagemSemQuizzes = $MarginContainer/ItensTela/ScrollContainer/MeusQuizzesContainer/LabelSemQuizzes


func _process(delta):
	_labelMensagemSemQuizzes.visible = true if !quizzes else false


func _ready():
	quizzes = Quizzes.new().getQuizzesDoUsuario(SessaoUsuario.usuarioLogado.idUsuario)
	criaQuizzes()
	

func criaQuizzes():
	if(quizzes):
		for quiz in quizzes:
			var cardComponente = preload("res://componentes/cardMeusQuizzes/cardMeusQuizzes.tscn").instantiate()
			
			#Coloca as propriedades
			cardComponente.perguntaId = quiz.quizId
			cardComponente.tituloDoQuiz = quiz.titulo
			
			#Insere o card do quiz
			_meusQuizzesContainer.add_child(cardComponente)
