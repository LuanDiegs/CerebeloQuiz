extends PanelContainer
class_name EscolhaAlternativaQuiz

#Variaveis iniciais
var posicaoInicial: Vector2
var isEntradaEsquerda: bool = true


func _ready() -> void:
	posicaoInicial = self.position
	pass
	

func entradaPergunta():
	var tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	var posicaoCardEscondido = posicaoInicial.x*-4 if isEntradaEsquerda else posicaoInicial.x*4
	
	tween.tween_property(self, "position:x", posicaoCardEscondido, 0.001)
	tween.tween_property(self, "position:x", posicaoInicial.x, 0.6)
	
	await tween.finished


func saidaPergunta():
	var tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	var antecipacaoPosicao = posicaoInicial.x - 100 if isEntradaEsquerda else posicaoInicial.x + 100
	var objetivoPosicao = posicaoInicial.x + 1000 if isEntradaEsquerda else posicaoInicial.x - 1000
	
	tween.tween_property(self, "position:x", antecipacaoPosicao, 0.15)
	tween.tween_property(self, "position:x", objetivoPosicao, 0.4)
	
	await tween.finished	
	self.queue_free()
