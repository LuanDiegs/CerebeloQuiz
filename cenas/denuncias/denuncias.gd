extends Control
class_name Denuncias

var denuncias: Dictionary

@onready var _containerDenuncias = $MarginDenuncias/VBoxContainer/ScrollContainer/ContainerDenuncias

func _ready():
	denuncias = Denuncia.new().getDenunciasFormatadas()
	
	for denuncia in denuncias:
		var cardInstanciado = preload("res://componentes/denunciaPage/cardDenuncia.tscn").instantiate()
		var informacoesDenuncia = denuncias.get(denuncia)
		
		_containerDenuncias.add_child(cardInstanciado)
		cardInstanciado.insereInformacoesPrincipais(
			denuncia,
			informacoesDenuncia.quizTitulo, 
			informacoesDenuncia.quantidadeDenuncias, 
			informacoesDenuncia.motivos)

	
