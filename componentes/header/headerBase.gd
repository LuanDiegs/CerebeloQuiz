extends PanelContainer
class_name  HeaderBase


@onready var _inputPesquisa = $Header/Botoes/InputPesquisa
@onready var _filtroSelect = $Header/Botoes/FiltroSelect

signal filtrarQuizzes(filtro: String)


func _ready():
	_inputPesquisa.connect("text_changed", trocarTextoFiltro)
	_filtroSelect.connect("item_selected", trocarTextoFiltro)
	
	#PreencheCategorias
	var categorias = CategoriasQuiz.new().getCategoriasQuiz()
	for categoria in categorias:
		_filtroSelect.add_item(categoria.descricao, categoria.categoriaId)


func trocarTextoFiltro(filtro):
	var categoria = null if _filtroSelect.get_selected_id() == 0 else _filtroSelect.get_selected_id()
	filtro = _inputPesquisa.text
	
	var quizzes = Quizzes.new().getTodosQuizzesPublicos(filtro, categoria)
	filtrarQuizzes.emit(quizzes)
