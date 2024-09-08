extends Panel
class_name ContainerAlternativaFormQuiz

@onready var botaoRemover = $MarginConteudo/Conteudos/BotaoRemover as Button

var isAlternativaCorreta := false
var conteudoAlternativaTexto := ""
@onready var conteudoAlternativaInput = $MarginConteudo/Conteudos/ConteudoAlternativa as TextEdit


func _process(delta):
	botaoRemover.visible = get_tree().get_nodes_in_group("alternativa").size() > ConstantesPadroes.MINIMO_ALTERNATIVA_PERGUNTA
	if(self.get_index() == 0):
		isAlternativaCorreta = true
		
	
func _ready():
	botaoRemover.connect("pressed", removeAlternativa)
	conteudoAlternativaInput.connect("text_changed", func(): conteudoAlternativaTexto = conteudoAlternativaInput.text)
	
	conteudoAlternativaInput.text = conteudoAlternativaTexto
	
	
func removeAlternativa():
	self.queue_free()


func verificaSeBotaoApagarFicaVisivel():
	if(get_tree().get_nodes_in_group("alternativa").size() > ConstantesPadroes.MINIMO_ALTERNATIVA_PERGUNTA):
		var tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
		tween.tween_property(botaoRemover, "scale", Vector2(1.1,1.1), 0.1)
		tween.tween_property(botaoRemover, "scale", Vector2(0,0), 0.1)
		await tween.finished
		
		botaoRemover.visible = false
