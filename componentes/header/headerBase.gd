extends PanelContainer
class_name  HeaderBase


@onready var inputPesquisa = $Header/Botoes/InputPesquisa
signal filtrarQuizzes(filtro: String)


func _ready():
	inputPesquisa.connect("text_changed", trocarTextoFiltro)


func trocarTextoFiltro(filtro: String):
	var quizzes = Quizzes.new().getTodosQuizzesPublicos(filtro)
	filtrarQuizzes.emit(quizzes)
