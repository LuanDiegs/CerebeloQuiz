extends Control
class_name Denuncias

var denuncias: Dictionary

@onready var _containerDenuncias = $MarginDenuncias/VBoxContainer/ScrollContainer/ContainerDenuncias

func _ready():
	_inserirDenuncias()


func _inserirDenuncias():
	denuncias = Denuncia.new().getDenunciasFormatadas()
	
	for denuncia in denuncias:
		var cardInstanciado = preload("res://componentes/denunciaPage/cardDenuncia.tscn").instantiate()
		var informacoesDenuncia = denuncias.get(denuncia)
		
		_containerDenuncias.add_child(cardInstanciado)
		cardInstanciado.insereInformacoesPrincipais(
			denuncia,
			informacoesDenuncia.usuarioId, 
			informacoesDenuncia.quizTitulo, 
			informacoesDenuncia.quantidadeDenuncias, 
			informacoesDenuncia.motivos)
		cardInstanciado.connect("precisaAtualizarGrid", _atualizaGrid)
		
	
func _atualizaGrid():
	var denuncias = _containerDenuncias.get_children()
	
	for denuncia in denuncias:
		_containerDenuncias.remove_child(denuncia)
	
	_inserirDenuncias()
