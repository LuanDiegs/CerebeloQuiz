extends Control
class_name MeusQuizzes

var _quizzes: Array

@onready var _meusQuizzesContainer = $MarginContainer/ItensTela/ScrollContainer/MeusQuizzesContainer
@onready var _labelMensagemSemQuizzes = $MarginContainer/ItensTela/ScrollContainer/MeusQuizzesContainer/LabelSemQuizzes
@onready var _headerMeusQuizzes = $MarginContainer/ItensTela/HeaderMeusQuizzes


func _process(_delta):
	_labelMensagemSemQuizzes.visible = true if _quizzes.size() == 0 else false


func _ready():
	_quizzes = Quizzes.new().getQuizzesDoUsuario(SessaoUsuario.usuarioLogado.idUsuario)
	_criaQuizzes()
	
	_headerMeusQuizzes.connect("filtrarQuizzes", _filtraQuizzes)
	

func _criaQuizzes():
	if(_quizzes):
		for quiz in _quizzes:
			var cardComponente = preload("res://componentes/cardMeusQuizzes/cardMeusQuizzes.tscn").instantiate()
			
			#Coloca as propriedades
			cardComponente.quizId = quiz.quizId
			cardComponente.tituloDoQuiz = quiz.titulo
			cardComponente.isDesativado = quiz.isDesativado
			
			#Insere o card do quiz
			_meusQuizzesContainer.add_child(cardComponente)
			
			#Insere a categoria
			cardComponente.inserirCategoria(quiz.descricaoCategoria)

func _deletaOsQuizzesNaGrid():
	for quiz in _meusQuizzesContainer.get_children():
		if(quiz is CardMeusQuizzes):
			_meusQuizzesContainer.remove_child(quiz)


func atualizarGridMeusQuizzes():
	_quizzes = Quizzes.new().getQuizzesDoUsuario(SessaoUsuario.usuarioLogado.idUsuario)
	_deletaOsQuizzesNaGrid()
	_criaQuizzes()


func _filtraQuizzes(quizzes):
	_quizzes = quizzes
	_deletaOsQuizzesNaGrid()
	_criaQuizzes()
