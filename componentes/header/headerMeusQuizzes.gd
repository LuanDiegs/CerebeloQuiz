extends HeaderPopulares
class_name HeaderMeusQuizzes

@onready var _botaoCriarQuiz = $Header/Botoes/BotaoCriarQuiz
@onready var _inputPesquisa = $Header/Botoes/InputPesquisa

func _ready():
	_botaoCriarQuiz.connect("pressed", func(): TransicaoCena.trocar_cena(TransicaoCena.telaEditFormQuiz))
	_inputPesquisa.connect("text_changed", trocarTextoFiltro)


func trocarTextoFiltro(filtro: String):
	var quizzes = Quizzes.new().getQuizzesDoUsuario(SessaoUsuario.usuarioLogado.idUsuario, filtro)
	filtrarQuizzes.emit(quizzes)
