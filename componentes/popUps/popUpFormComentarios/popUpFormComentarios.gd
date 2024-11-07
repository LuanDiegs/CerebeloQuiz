extends PopUpBase
class_name PopUpFormComentariosPergunta

@onready var _popUp = $PopUp
@onready var _fecharBotao = $PopUp/ContainerVertical/Titulo/FecharModal

@onready var _gridComentarios = $PopUp/ContainerVertical/ScrollComentarios/MarginComentarios/GridComentarios

var _perguntaId: int

func definePropriedadesDoComentario(perguntaId: int):
	_perguntaId = perguntaId
	

func _ready() -> void:
	_fecharBotao.connect("pressed", fechaPopup)
	_insereComentarios()
		

func _insereComentarios():
	#Cria os comentários
	var comentarios = Comentario.new().getComentariosDaPergunta(_perguntaId)

	for comentario in comentarios:
		var comentarioComponente = preload("res://cenas/meusQuizzes/cardComentarioFormComentario/painelComentarios.tscn").instantiate()
	
		_gridComentarios.add_child(comentarioComponente)
		comentarioComponente.inserePropriedadesDoComponente(
			comentario.comentarioId,
			comentario.perguntaId,
			comentario.nome, 
			comentario.comentarioDescricao,
			comentario.isFixado)
			
		comentarioComponente.connect("fixouComentario", _atualizaComentarios)
			
			
func _atualizaComentarios():
	for comentario in _gridComentarios.get_children():
		_gridComentarios.remove_child(comentario)
	
	_insereComentarios()


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
