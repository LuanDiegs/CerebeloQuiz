extends Control
class_name HeaderMeusQuizzes

@onready var _botaoCriarQuiz = $Header/Botoes/BotaoCriarQuiz


func _ready():
	_botaoCriarQuiz.connect("pressed", func(): TransicaoCena.trocar_cena(TransicaoCena.telaEditFormQuiz))
