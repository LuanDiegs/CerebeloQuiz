extends Panel
class_name ContainerAlternativaFormQuiz

@onready var botaoRemover = $MarginConteudo/Conteudos/BotaoRemover as Button

var alternativaId := 0
var isAlternativaCorreta := false 
var conteudoAlternativaTexto := ""
@onready var _conteudoAlternativaInput = $MarginConteudo/Conteudos/ConteudoAlternativa as TextEdit

#Temas
const _temaAlternativaIncorreto = preload("res://componentes/containerAlternativaFormQuiz/containerAlternativaIncorretaFormQuizTema.tres")
const _temaAlternativaCorreta = preload("res://componentes/containerAlternativaFormQuiz/containerAlternativaCorretaFormQuizTema.tres")


func _process(delta):
	botaoRemover.visible = get_tree().get_nodes_in_group("alternativa").size() > ConstantesPadroes.MINIMO_ALTERNATIVA_PERGUNTA
	
	if(self.get_index() == 0):
		isAlternativaCorreta = true
		_conteudoAlternativaInput.placeholder_text = "Digite aqui a alternativa correta..."
		self.theme = _temaAlternativaCorreta
	else:
		isAlternativaCorreta = false
		_conteudoAlternativaInput.placeholder_text = "Digite aqui a alternativa incorreta..."
		self.theme = _temaAlternativaIncorreto


func _ready():
	botaoRemover.connect("pressed", removeAlternativa)
	_conteudoAlternativaInput.connect("text_changed", func(): conteudoAlternativaTexto = _conteudoAlternativaInput.text)
	
	_conteudoAlternativaInput.text = conteudoAlternativaTexto
	
	
func removeAlternativa():
	self.queue_free()
