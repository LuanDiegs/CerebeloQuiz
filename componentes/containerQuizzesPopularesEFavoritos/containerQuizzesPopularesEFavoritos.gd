extends ScrollContainer
class_name ContainerQuizzesPopularesEFavoritos

@onready var _quizzesGrid: GridContainer = $MarginContainer/GridContainer
@onready var _quizzes: Array


func inserirQuizzes(quizzes: Array):
	_quizzes = quizzes
	for quiz in _quizzes:
		var quizCardComponente = preload("res://componentes/cards/cardQuizPopularEFavoritos.tscn").instantiate() as CardBase
		quizCardComponente.quizId = quiz.quizId
		quizCardComponente.usuarioId = quiz.usuarioId
		quizCardComponente.titulo = quiz.titulo 
		quizCardComponente.criador = quiz.nome
			
		_quizzesGrid.add_child(quizCardComponente)
		
		quizCardComponente.inserirCategoria(quiz.descricaoCategoria)


func atualizaQuizzes(quizzes: Array):
	for quiz in _quizzesGrid.get_children():
		_quizzesGrid.remove_child(quiz)
	
	inserirQuizzes(quizzes)
