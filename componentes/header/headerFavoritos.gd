extends HeaderBase
class_name HeaderFavoritos

@onready var _inputPesquisa = $Header/Botoes/InputPesquisa

func _ready():
	_inputPesquisa.connect("text_changed", trocarTextoFiltro)


func trocarTextoFiltro(filtro: String):
	var quizzes = Quizzes.new().getTodosQuizzesFavoritadosPublicos(filtro)
	filtrarQuizzes.emit(quizzes)
