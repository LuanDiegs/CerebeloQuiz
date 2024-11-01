extends MarginContainer
class_name CardDenuncia

@onready var _nomeDoQuizLabel = $PainelCardDenuncia/MarginContainer/Conteudo/InformacoesPrincipais/NomeDoQuizLabel
@onready var _quantidadeDenunciasLabel = $PainelCardDenuncia/MarginContainer/Conteudo/InformacoesPrincipais/ContagemDenunciasContainer/ContagemDenuncias
@onready var _containerPorgentagemMotivoDenuncia = $PainelCardDenuncia/MarginContainer/Conteudo/Denuncias/ContainerPorcentagemDenuncia

@onready var _verJustificativasBotao = $PainelCardDenuncia/MarginContainer/Conteudo/InformacoesPrincipais/VerJustificativas

var _quizTitulo: String = ""
var _quizId: int = 0
var _usuarioDoQuizId: int = 0

signal precisaAtualizarGrid

func _ready():
	_verJustificativasBotao.connect("pressed", abrirPopUpJustificativas)


func insereInformacoesPrincipais(
	quizId: int, 
	usuarioQuizId: int,
	nomeDoQuiz: String, 
	quantidadeDenuncias: int, 
	motivos: Array):
	_quizId = quizId
	_usuarioDoQuizId = usuarioQuizId
	_quizTitulo = nomeDoQuiz
	_nomeDoQuizLabel.text = _quizTitulo
	
	_quantidadeDenunciasLabel.text = str(quantidadeDenuncias)
	
	inserePorcentagemMotivosDenuncias(motivos)
	

func inserePorcentagemMotivosDenuncias(motivos: Array):
	var quantidadeTotalDenunciasArray: Array = [0]
	motivos.map(func(valor: Dictionary): quantidadeTotalDenunciasArray.append(valor.values()[0]))
	
	for i in motivos.size():
		if i >= 3:
			continue
			
		var porcentagemMotivoDenuncia = preload("res://componentes/denunciaPage/porcentagemDenuncia.tscn").instantiate()
		var motivo = motivos[i] as Dictionary
		
		_containerPorgentagemMotivoDenuncia.add_child(porcentagemMotivoDenuncia)
		porcentagemMotivoDenuncia.insereInformacoesMotivoPorcentagem(
			motivo.keys()[0], 
			Utils.somaValoresArray(quantidadeTotalDenunciasArray),
			motivo.values()[0])


func abrirPopUpJustificativas():
	var popup = PopUp.criaPopupDenunciaModerador(_quizId, _usuarioDoQuizId, _quizTitulo)
	popup.connect("precisaAtualizarGrid", func(): precisaAtualizarGrid.emit())
