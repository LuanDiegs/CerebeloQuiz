extends Button
class_name BotaoMenuSidebar

@export var redirecionarPara: String


func _on_pressed():
	TransicaoCena.trocar_cena(redirecionarPara)
	
