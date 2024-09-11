extends PanelContainer
class_name EscolhaAlternativaQuiz

#Variaveis iniciais
var posicaoInicial: Vector2
var isEntradaEsquerda: bool = true

#Perguntas
var perguntaId := 0
var perguntaConteudo := ""
@onready var textoPergunta = $QuizEAlternativas/QuizTexto/TextoPergunta

#Alternativas
var alternativas: Array
@onready var quizEAlternativas = $QuizEAlternativas as VBoxContainer


func _ready() -> void:
	posicaoInicial = self.position
	
	#Insere o texto da pergunta
	textoPergunta.text = perguntaConteudo

	#Insere as alternativas
	if(alternativas):
		insereAlternativas()


func entradaPergunta(eliminaNodeAposEntrar: bool = false):
	var tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	var posicaoCardEscondido = posicaoInicial.x*-4 if isEntradaEsquerda else posicaoInicial.x*5
	
	tween.tween_property(self, "position:x", posicaoCardEscondido, 0.001)
	tween.tween_property(self, "position:x", posicaoInicial.x, 0.9)
	
	await tween.finished
	
	if(eliminaNodeAposEntrar):
		self.queue_free()


func saidaPergunta():
	var tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	var antecipacaoPosicao = posicaoInicial.x - 100 if isEntradaEsquerda else posicaoInicial.x + 100 
	var objetivoPosicao = posicaoInicial.x + 1500 if isEntradaEsquerda else posicaoInicial.x - 1500
	
	tween.tween_property(self, "position:x", antecipacaoPosicao, 0.25)
	tween.tween_property(self, "position:x", objetivoPosicao, 0.65)
	
	await tween.finished	
	self.queue_free()


func insereAlternativas():
	for alternativa in alternativas:
		var alternativaBotao = Button.new()
		alternativaBotao.text = alternativa.conteudoAlternativa
		quizEAlternativas.add_child(alternativaBotao)
