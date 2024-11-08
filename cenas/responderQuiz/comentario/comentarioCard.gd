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
	
	_alteraTemaComentarioFixado(isFixado)
	_toggleBotaoCurtidaDescurtida()


func _alteraTemaComentarioFixado(isFixado: bool):
	_isFixado = isFixado
	if _isFixado:
		var estiloComentarioFicado = preload("res://cenas/responderQuiz/comentario/comentarioCardFixado.tres")
		
		_fixadoPeloCriadorLabel.visible = true
		self.add_theme_stylebox_override("panel", estiloComentarioFicado)


func _curtirBotaoClick():
	var acao = CurtidasDescurtidasComentario.new().acaoComentario
	_curtirDescurtirComentario(acao.Curtida)
	

func _descurtirBotaoClick():
	var acao = CurtidasDescurtidasComentario.new().acaoComentario
	_curtirDescurtirComentario(acao.Descurtida)


func _curtirDescurtirComentario(acaoComentario):
	if !SessaoUsuario.isLogada:
		PopUp.criaPopupNotificacao("Somente usuários logados podem curtir/descurtir um comentário")
		_curtirBotao.button_pressed = false		
		_descurtirBotao.button_pressed = false
		return
	
	var acao = CurtidasDescurtidasComentario.new().acaoComentario
	
	if CurtidasDescurtidasComentario.new().inserirCurtidaDescurtidaComentario(_comentarioId, acaoComentario):	
		var quantidades = CurtidasDescurtidasComentario.new().getQuantidadeCurtidasDescurtidasComentario(_comentarioId) as Array

		if quantidades:
			var curtidaOuDescurtida = quantidades[0]
			_insereQuantidadeCurtidaDescurtida(curtidaOuDescurtida)
		
			if quantidades.size() > 1:
				var curtidaOuDescurtidaNova = quantidades[1]
				_insereQuantidadeCurtidaDescurtida(curtidaOuDescurtidaNova)
				
		_toggleBotaoCurtidaDescurtida()


func _insereQuantidadeCurtidaDescurtida(curtidaOuDescurtidaDic: Dictionary):
	var acao = CurtidasDescurtidasComentario.new().acaoComentario
	
	if curtidaOuDescurtidaDic.acao == acao.Curtida:
		_quantidadeCurtidas = curtidaOuDescurtidaDic.quantidade
		_curtirBotao.text = str(_quantidadeCurtidas)
	else:
		_quantidadeDescurtidas = curtidaOuDescurtidaDic.quantidade
		_descurtirBotao.text = str(_quantidadeDescurtidas)


func _toggleBotaoCurtidaDescurtida():
	if !SessaoUsuario.isLogada:
		return
		
	var curtidaDescurtidaDoUsuario = CurtidasDescurtidasComentario.new().getCurtidaDescurtidaDoUsuarioNoComentario(_comentarioId)

	if curtidaDescurtidaDoUsuario.size() > 0:
		var isCurtida = curtidaDescurtidaDoUsuario[0].acao == 1
		var isDescurtida = curtidaDescurtidaDoUsuario[0].acao == 2
		
		_curtirBotao.button_pressed = isCurtida
		_curtirBotao.disabled = isCurtida
		
		_descurtirBotao.button_pressed = isDescurtida
		_descurtirBotao.disabled = isDescurtida
