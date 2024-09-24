extends ScrollContainer
class_name ContainerQuizzesPopularesEFavoritos

@onready var _quizzesGrid: GridContainer = $GridContainer
@onready var _quizzes: Array


func inserirQuizzes(quizzes: Array):
	_quizzes = quizzes
	for quiz in _quizzes:
		var quizCardComponente = preload("res://componentes/cards/cardQuizPopularEFavoritos.tscn").instantiate() as CardBase
		quizCardComponente.quizId = quiz.quizId
		quizCardComponente.titulo = quiz.titulo 
		quizCardComponente.criador = quiz.nome
		
		_quizzesGrid.add_child(quizCardComponente)
