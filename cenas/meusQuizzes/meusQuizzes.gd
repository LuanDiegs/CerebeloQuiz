extends Control
class_name MeusQuizzes

var quizzes: Array

@onready var _meusQuizzesContainer = $MarginContainer/ItensTela/ScrollContainer/MeusQuizzesContainer
@onready var _labelMensagemSemQuizzes = $MarginContainer/ItensTela/ScrollContainer/MeusQuizzesContainer/LabelSemQuizzes


func _process(delta):
	_labelMensagemSemQuizzes.visible = true if quizzes.size() == 0 else false
	print(quizzes.size())


func _ready():
	quizzes = Quizzes.new().getQuizzesDoUsuario(SessaoUsuario.usuarioLogado.idUsuario)
	_criaQuizzes()
	

func _criaQuizzes():
	if(quizzes):
		for quiz in quizzes:
			var cardComponente = preload("res://componentes/cardMeusQuizzes/cardMeusQuizzes.tscn").instantiate()
			
			#Coloca as propriedades
			cardComponente.quizId = quiz.quizId
			cardComponente.tituloDoQuiz = quiz.titulo
			
			#Insere o card do quiz
			_meusQuizzesContainer.add_child(cardComponente)
		

func _deletaOsQuizzesNaGrid():
	for quiz in _meusQuizzesContainer.get_children():
		if(quiz is CardMeusQuizzes):
			_meusQuizzesContainer.remove_child(quiz)


func atualizarGridMeusQuizzes():
	_deletaOsQuizzesNaGrid()
	quizzes = Quizzes.new().getQuizzesDoUsuario(SessaoUsuario.usuarioLogado.idUsuario)
	print(quizzes)
	_criaQuizzes()
