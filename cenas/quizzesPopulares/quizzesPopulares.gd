extends Control
class_name QuizzesPopulares

@onready var _containerQuizzesPopulares = $MarginContainer/ItensDaTela/ContainerQuizzesPopulares
@onready var _header = $MarginContainer/ItensDaTela/Header

func _ready():
	_insereQuizzes()
	_header.connect("filtrarQuizzes", _filtraQuizzes)
	

func atualizarGridQuizzes():
	var quizzes = Quizzes.new().getTodosQuizzesPublicos()
	_containerQuizzesPopulares.atualizaQuizzes(quizzes)


func _insereQuizzes():
	var quizzes = Quizzes.new().getTodosQuizzesPublicos()
	_containerQuizzesPopulares.inserirQuizzes(quizzes)


func _filtraQuizzes(quizzes):
	_containerQuizzesPopulares.atualizaQuizzes(quizzes)
	
