extends Control
class_name QuizzesPopulares

@onready var _containerQuizzesPopulares = $MarginContainer/ItensDaTela/ContainerQuizzesPopulares

func _ready():
	var quizzes = Quizzes.new().getTodosQuizzesPublicos()
	_containerQuizzesPopulares.inserirQuizzes(quizzes)
