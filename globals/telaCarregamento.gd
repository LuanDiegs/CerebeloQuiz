extends Panel
class_name TelaDeCarregamento

var carregando = false
	
func exibeTelaDeCarregamento():
	var telaDeCarregamento = preload("res://componentes/telaDeCarregamento/telaDeCarregamento.tscn").instantiate()
	
	#Cria o componente na tela
	get_tree().root.add_child(telaDeCarregamento)
