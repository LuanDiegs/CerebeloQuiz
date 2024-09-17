extends Panel
class_name CardBase

#Apenas teste
@onready var jogarBotao = $BtJogar
@onready var jogaTwitchBotao = $BtJogarTwitch

func _ready():
	jogarBotao.connect("pressed", editarQuizTeste)
	jogaTwitchBotao.connect("pressed", editarQuizTwitchTeste)
	

func editarQuizTeste():
	TransicaoCena.trocar_cena(TransicaoCena.telaResponderQuiz)
	
func editarQuizTwitchTeste():
	TransicaoCena.trocar_cena(TransicaoCena.telaResponderQuizTwitch)
