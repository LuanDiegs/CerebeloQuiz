extends Button
class_name BotaoMenuSidebar

@export var redirecionarPara: String


func _ready():
	connect("pressed", _on_pressed)
	
	if(!self.is_in_group("botaoPerfil")):
		connect("mouse_entered", _on_hover)
		connect("mouse_exited", _on_hover)
		
	#Coloca o mouse de clicar ao entrar no botão
	mouse_default_cursor_shape = CURSOR_POINTING_HAND


func _on_pressed():
	if !redirecionarPara.is_empty():
		TransicaoCena.trocar_cena(redirecionarPara)


func _on_hover():
	#Animation tween
	var tween = create_tween()
	
	if(self.is_hovered()):
		tween.tween_property(self, "size", Vector2(230, 65), 0.2).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CIRC)
	else:
		tween.tween_property(self, "size", Vector2(250, 65), 0.2).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CIRC)
