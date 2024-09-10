extends MarginContainer
class_name CardMeusQuizzes

var perguntaId := 0
var tituloDoQuiz := ""

#Propriedades
@onready var _tituloQuiz = $PainelMeusQuizzes/MarginDentroDoPanel/Elementos/TituloQuiz

#Botões
@onready var _editarBotao = $PainelMeusQuizzes/MarginDentroDoPanel/Elementos/BotoesContainer/Editar


func _ready():
	_editarBotao.connect("pressed", editarQuiz)
	_tituloQuiz.text = tituloDoQuiz


func editarQuiz():
	TransicaoCena.trocar_cena(TransicaoCena.telaEditFormQuiz, perguntaId)
