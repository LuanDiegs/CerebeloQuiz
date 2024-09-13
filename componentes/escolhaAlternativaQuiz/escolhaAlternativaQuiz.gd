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

#Resposta
var alternativaEscolhida: int


func _ready() -> void:
	posicaoInicial = self.global_position
	
	#Insere o texto da pergunta
	textoPergunta.text = perguntaConteudo

	#Insere as alternativas
	if(alternativas):
		insereAlternativas()


func entradaPergunta():
	var tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	var posicaoCardEscondido = posicaoInicial.x*-4 if isEntradaEsquerda else posicaoInicial.x*5
	
	tween.tween_property(self, "position:x", posicaoCardEscondido, 0.001)
	tween.tween_property(self, "position:x", posicaoInicial.x, 0.9)
	
	await tween.finished


func saidaPergunta():
	var tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	var antecipacaoPosicao = posicaoInicial.x - 100 if isEntradaEsquerda else posicaoInicial.x + 100 
	var objetivoPosicao = posicaoInicial.x + 1500 if isEntradaEsquerda else posicaoInicial.x - 1500
		
	tween.tween_property(self, "position:x", antecipacaoPosicao, 0.25)
	tween.tween_property(self, "position:x", objetivoPosicao, 0.65)
	
	await tween.finished


func insereAlternativas():
	#Randomiza 3 vezes para randomizar as alternativas
	alternativas.shuffle()
	alternativas.shuffle()
	
	#Cria um novo grupo
	var botaoGrupo = ButtonGroup.new()

	for alternativa in alternativas:
		var botaoEscolherAlternativa = load("res://componentes/botoes/botaoEscolherAlternativa/botaoEscolherAlternativa.tscn").instantiate() as BotaoEscolherAlternativa
		
		botaoEscolherAlternativa.text = alternativa.conteudoAlternativa
		botaoEscolherAlternativa.isAlternativaCorreta = alternativa.isAlternativaCorreta
		botaoEscolherAlternativa.button_group = botaoGrupo

		quizEAlternativas.add_child(botaoEscolherAlternativa)