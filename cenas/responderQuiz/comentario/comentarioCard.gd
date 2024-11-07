extends PanelContainer
class_name ComentarioCard

@onready var _nomeUsuarioComentario = $Margin/ItensDoComentario/NomeUsuarioComentario
@onready var _comentarioLabel = $"Margin/ItensDoComentario/Itens/PainelComentario/Comentário"
@onready var _fixadoPeloCriadorLabel = $Margin/ItensDoComentario/FixadoPeloCriador

@onready var _curtirBotao = $Margin/ItensDoComentario/Itens/BotoesCurtir/Curtir
var _quantidadeCurtidas = 0
@onready var _descurtirBotao = $Margin/ItensDoComentario/Itens/BotoesCurtir/Descurtir
var _quantidadeDescurtidas = 0


var _comentarioId = 0
var _isFixado = false

func _ready():
	_curtirBotao.connect("pressed", _curtirBotaoClick)
	_descurtirBotao.connect("pressed", _descurtirBotaoClick)


func inserirInformacoesDoComentario(
		id: int, 
		nomeUsuario: String, 
		comentario: String,
		quantidadeCurtidas: int, 
		quantidadeDecurtidas: int, 
		isFixado: bool):
	_comentarioId = id
	_nomeUsuarioComentario.text = nomeUsuario
	_comentarioLabel.text = comentario
	_quantidadeCurtidas = quantidadeCurtidas
	_curtirBotao.text = str(_quantidadeCurtidas)
	_quantidadeDescurtidas = quantidadeDecurtidas
	_descurtirBotao.text = str(quantidadeDecurtidas)
	
	_isFixado = isFixado
	if _isFixado:
		var estiloComentarioFicado = preload("res://cenas/responderQuiz/comentario/comentarioCardFixado.tres")
		
		_fixadoPeloCriadorLabel.visible = true
		self.add_theme_stylebox_override("panel", estiloComentarioFicado)


func _curtirBotaoClick():
	var novaQuantidade = _quantidadeCurtidas + 1
	var response = Comentario.new().incrementaQuantidadeCurtidaComentario(_comentarioId, novaQuantidade)
	
	_quantidadeCurtidas = novaQuantidade
	_curtirBotao.text = str(novaQuantidade)
	

func _descurtirBotaoClick():
	var novaQuantidade = _quantidadeDescurtidas + 1
	var response = Comentario.new().incrementaQuantidadeDescurtidaComentario(_comentarioId, novaQuantidade)
	
	_quantidadeDescurtidas = novaQuantidade
	_descurtirBotao.text = str(novaQuantidade)
