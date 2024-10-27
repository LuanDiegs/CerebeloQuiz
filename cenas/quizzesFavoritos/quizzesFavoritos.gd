extends Control
class_name QuizzesFavoritos

@onready var _containerQuizzesFavoritos := $MarginContainer/ItensTela/ContainerQuizzesPopularesEFavoritos
@onready var _headerFavoritos = $MarginContainer/ItensTela/Header

func _ready():
	var quizzes = Quizzes.new().getTodosQuizzesFavoritadosPublicos()
	_containerQuizzesFavoritos.inserirQuizzes(quizzes)
	
	_headerFavoritos.connect("filtrarQuizzes", _filtraQuizzes)


func atualizaQuizzes():
	var quizzes = Quizzes.new().getTodosQuizzesFavoritadosPublicos()
	_containerQuizzesFavoritos.atualizaQuizzes(quizzes)


func _filtraQuizzes(quizzes):
	_containerQuizzesFavoritos.atualizaQuizzes(quizzes)
