extends PopUpBase
class_name PopUpRankingQuiz

@onready var _popUp: Panel = $PopUp
@onready var _fecharBotao: Button = $PopUp/ContainerVertical/MarginRanking/ItensContainer/FecharModal
@onready var _fecharSuperior = $PopUp/ContainerVertical/Titulo/FecharModal
@onready var _rankingContainer = $PopUp/ContainerVertical/MarginRanking/ItensContainer/Ranking

var quizId: int

func _ready() -> void:
	_fecharBotao.connect("pressed", fechaPopup)
	_fecharSuperior.connect("pressed", fechaPopup)
	
	#Cria a pontuação
	var dadosRanking = RankingPessoal.new().getRankingDoQuiz(quizId)
	for dado in dadosRanking:
		if(_rankingContainer.get_child_count() == 11):
			return
			
		var itemPontuacao = preload("res://componentes/popUps/popUpRankingQuiz/itemPontuacao.tscn").instantiate()
		_rankingContainer.add_child(itemPontuacao)
		itemPontuacao.inserePontuacaoEUsuario(dado.usuario, dado.pontuacao)


func animaEntrada():
	_popUp.scale = Vector2(0,0)
	_popUp.pivot_offset.x = _popUp.size.x/2
	_popUp.pivot_offset.y = _popUp.size.y/2
	
	var tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	tween.tween_property(_popUp, "scale", Vector2(0,0), 0.00001)
	tween.tween_property(_popUp, "scale", Vector2(1.15,1.15), 0.3)
	tween.tween_property(_popUp, "scale", Vector2(1,1), 0.2)
	await tween.finished


func fechaPopup():
	var tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	tween.tween_property(_popUp, "scale", Vector2(1.1,1.1), 0.2)
	tween.tween_property(_popUp, "scale", Vector2(0,0), 0.3)
	await tween.finished
	self.queue_free()


func _on_gui_input(event: InputEvent) -> void:
	if(event.is_action_pressed("CliqueDireito")):
		fechaPopup()
