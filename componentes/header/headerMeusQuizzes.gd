extends HeaderPopulares
class_name HeaderMeusQuizzes

@onready var _botaoCriarQuiz = $Header/Botoes/BotaoCriarQuiz

func _ready():
	_botaoCriarQuiz.connect("pressed", func(): TransicaoCena.trocar_cena(TransicaoCena.telaEditFormQuiz))
	_inputPesquisa.connect("text_changed", trocarTextoFiltro)
	_filtroSelect.connect("item_selected", trocarTextoFiltro)
	
	#PreencheCategorias
	var categorias = CategoriasQuiz.new().getCategoriasQuiz()
	for categoria in categorias:
		_filtroSelect.add_item(categoria.descricao, categoria.categoriaId)


func trocarTextoFiltro(filtro):
	var categoria = null if _filtroSelect.get_selected_id() == 0 else _filtroSelect.get_selected_id()
	filtro = _inputPesquisa.text
	
	var quizzes = Quizzes.new().getQuizzesDoUsuario(SessaoUsuario.usuarioLogado.idUsuario, filtro, categoria)
	filtrarQuizzes.emit(quizzes)
