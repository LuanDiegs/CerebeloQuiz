extends Panel
class_name CardBase

#Apenas teste
@onready var jogarBotao = $BtJogar


func _ready():
	jogarBotao.connect("pressed", editarQuizTeste)
	

func editarQuizTeste():
	TransicaoCena.trocar_cena(TransicaoCena.telaResponderQuiz)
