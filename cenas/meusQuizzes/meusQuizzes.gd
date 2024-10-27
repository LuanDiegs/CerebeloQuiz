extends Control
class_name MeusQuizzes

var quizzes: Array

@onready var _meusQuizzesContainer = $MarginContainer/ItensTela/ScrollContainer/MeusQuizzesContainer
@onready var _labelMensagemSemQuizzes = $MarginContainer/ItensTela/ScrollContainer/MeusQuizzesContainer/LabelSemQuizzes
@onready var _headerMeusQuizzes = $MarginContainer/ItensTela/HeaderMeusQuizzes


func _process(delta):
	_labelMensagemSemQuizzes.visible = true if quizzes.size() == 0 else false


func _ready():
	quizzes = Quizzes.new().getQuizzesDoUsuario(SessaoUsuario.usuarioLogado.idUsuario)
	_criaQuizzes()
	
	_headerMeusQuizzes.connect("filtrarQuizzes", _filtraQuizzes)
	

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
	quizzes = Quizzes.new().getQuizzesDoUsuario(SessaoUsuario.usuarioLogado.idUsuario)
	_deletaOsQuizzesNaGrid()
	_criaQuizzes()


func _filtraQuizzes(quizzes):
	self.quizzes = quizzes
	_deletaOsQuizzesNaGrid()
	_criaQuizzes()
