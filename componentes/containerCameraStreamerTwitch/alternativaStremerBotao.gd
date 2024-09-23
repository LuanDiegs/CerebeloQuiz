extends Button
class_name BotaoAlternativaStreamer

var isAlternativaCorreta: bool = false
signal selecionouAlternativa


func _ready():
	self.connect("pressed", _selecionouAlternativa)
	var tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	tween.tween_property(self, "scale", Vector2.ZERO, 0.0001)
	tween.tween_property(self, "scale", Vector2(1.05, 1.05), 0.5)
	tween.tween_property(self, "scale", Vector2.ONE, 0.1)
	

func _draw():
	await get_tree().process_frame
	self.pivot_offset = self.size/2


func _selecionouAlternativa():
	var container = get_parent().get_parent()
	if container is ContainerCameraStreamerTwitch:
		container.desabilitaAlternativas(self.isAlternativaCorreta)
		selecionouAlternativa.emit()
