extends Panel
class_name PopUpBase

func _ready():
	self.scale = Vector2(0,0)


func abrirPopUp(componente: PopUpBase) -> void:
	get_tree().root.add_child(componente)
	
	var tween = create_tween()
	tween.tween_property(componente, "scale", Vector2(1,1), 0.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CIRC)
