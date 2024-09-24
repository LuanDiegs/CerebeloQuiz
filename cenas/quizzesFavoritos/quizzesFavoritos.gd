extends Control
class_name QuizzesFavoritos

@onready var _containerQuizzesFavoritos = $MarginContainer/ItensTela/ContainerQuizzesPopularesEFavoritos

func _ready():
	#TODO: Pegar os quizzes favoritos
	var quizzes = Quizzes.new().getTodosQuizzesPublicos()
	_containerQuizzesFavoritos.inserirQuizzes(quizzes)
