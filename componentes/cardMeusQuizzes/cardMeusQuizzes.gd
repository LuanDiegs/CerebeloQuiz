extends PanelContainer
class_name CardMeusQuizzes

var quizId := 0
var tituloDoQuiz := ""

#Propriedades
@onready var _tituloQuiz = $MarginDentroDoPanel/Elementos/TituloQuiz

#Botões
@onready var _editarBotao = $MarginDentroDoPanel/Elementos/BotoesContainer/Editar
@onready var _deletarBotao = $MarginDentroDoPanel/Elementos/BotoesContainer/Deletar


func _ready():
	_editarBotao.connect("pressed", _editarQuiz)
	_deletarBotao.connect("pressed", _deletarQuiz)
	_tituloQuiz.text = tituloDoQuiz
	
	print(get_tree().current_scene as MeusQuizzes)


func _editarQuiz():
	TransicaoCena.trocar_cena(TransicaoCena.telaEditFormQuiz, quizId)
	
	
func _deletarQuiz():
	PopUp.criaPopupConfirmacao(
		"Certeza que deseja deletar o quiz " + tituloDoQuiz,
		"Atenção",
		"Cancelar",
		Utils.criaBotaoAdicional("Confirmar", _deletarQuizBanco)
	)

func _deletarQuizBanco():
	if(Quizzes.new().deletarDado(EntidadeConstantes.QuizzesTabela, "quizId = " + str(quizId))):
		var cena = get_tree().current_scene as MeusQuizzes
		cena.atualizarGridMeusQuizzes()
		
		PopUp.criaPopupNotificacao("O Quiz foi excluído com sucesso!", "", "Sucesso")
		
