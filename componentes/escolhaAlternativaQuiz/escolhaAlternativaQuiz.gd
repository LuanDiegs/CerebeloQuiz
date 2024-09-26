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
var isTwitchQuiz: bool = false
var codigoAlternativaCorreta: String = ""
var alternativas: Array
@onready var quizEAlternativas = $QuizEAlternativas as VBoxContainer

#Resposta
var alternativaEscolhida: int

#Constantes
const ALTURA_MAXIMA := 60

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
	
	#Cria um novo grupo
	var botaoGrupo = ButtonGroup.new()
	
	for alternativa in alternativas:
		var botaoEscolherAlternativa = load("res://componentes/botoes/botaoEscolherAlternativa/botaoEscolherAlternativa.tscn").instantiate() as BotaoEscolherAlternativa
		
		botaoEscolherAlternativa.isAlternativaCorreta = alternativa.isAlternativaCorreta
		botaoEscolherAlternativa.button_group = botaoGrupo
		botaoEscolherAlternativa.disabled = isTwitchQuiz
		botaoEscolherAlternativa.mouse_default_cursor_shape = CURSOR_POINTING_HAND if !isTwitchQuiz else CURSOR_ARROW

		quizEAlternativas.add_child(botaoEscolherAlternativa)
		
		botaoEscolherAlternativa.insereTextoBotao(alternativa.conteudoAlternativa)

		#Limita a altura
		if botaoEscolherAlternativa.size.y > ALTURA_MAXIMA:
			botaoEscolherAlternativa.size.y = ALTURA_MAXIMA

		#Insere a alternativa da Twitch
		if isTwitchQuiz:
			var codigoOpcaoTwitch = "!" + str(botaoEscolherAlternativa.get_index()-1)
			var estiloDesabilitadoBotao := preload("res://componentes/botoes/botaoEscolherAlternativa/botaoEscolherAlternativaTypoDesabilitado.tres")
			
			#Coloca o estilo para não cobrir a opção da twitch no lado esquerdo
			estiloDesabilitadoBotao.content_margin_left = 35
			botaoEscolherAlternativa.theme.set_stylebox("disabled", "button", estiloDesabilitadoBotao)
			
			botaoEscolherAlternativa.inserirLabelAlternativaTwitch(codigoOpcaoTwitch)

			if alternativa.isAlternativaCorreta:
				codigoAlternativaCorreta = codigoOpcaoTwitch


func getAlternativaCorreta() -> BotaoEscolherAlternativa:
	for alternativa in quizEAlternativas.get_children():
		if alternativa is BotaoEscolherAlternativa and alternativa.isAlternativaCorreta:
			return alternativa

	return null
