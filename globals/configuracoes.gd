extends Node
class_name Configuracao

var isTelaInteira = false

func _input(event):
	if event.is_action_pressed("SetarTelaInteira"):
		var modoDeTela = DisplayServer.WINDOW_MODE_FULLSCREEN if !isTelaInteira else DisplayServer.WINDOW_MODE_WINDOWED
		DisplayServer.window_set_mode(modoDeTela, 0)
		isTelaInteira = !isTelaInteira
