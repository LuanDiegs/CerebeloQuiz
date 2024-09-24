extends PanelContainer
class_name CardMeusQuizzes

var perguntaId := 0
var tituloDoQuiz := ""

#Propriedades
@onready var _tituloQuiz = $MarginDentroDoPanel/Elementos/TituloQuiz

#Botões
@onready var _editarBotao = $MarginDentroDoPanel/Elementos/BotoesContainer/Editar


func _ready():
	_editarBotao.connect("pressed", editarQuiz)
	_tituloQuiz.text = tituloDoQuiz


func editarQuiz():
	TransicaoCena.trocar_cena(TransicaoCena.telaEditFormQuiz, perguntaId)
