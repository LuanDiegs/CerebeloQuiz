extends Control
class_name QuizzesPopulares

@onready var _containerQuizzesPopulares = $MarginContainer/ItensDaTela/ContainerQuizzesPopulares

func _ready():
	_insereQuizzes()
	

func atualizarGridQuizzes():
	var quizzes = Quizzes.new().getTodosQuizzesPublicos()
	_containerQuizzesPopulares.atualizaQuizzes(quizzes)


func _insereQuizzes():
	var quizzes = Quizzes.new().getTodosQuizzesPublicos()
	_containerQuizzesPopulares.inserirQuizzes(quizzes)
