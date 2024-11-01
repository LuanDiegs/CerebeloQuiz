extends PanelContainer
class_name ComentarioCard

@onready var _nomeUsuarioComentario = $Margin/ItensDoComentario/NomeUsuarioComentario
@onready var _comentarioLabel = $"Margin/ItensDoComentario/Itens/PainelComentario/Comentário"

@onready var _curtirBotao = $Margin/ItensDoComentario/Itens/BotoesCurtir/Curtir
@onready var _descurtirBotao = $Margin/ItensDoComentario/Itens/BotoesCurtir/Descurtir


func inserirInformacoesDoComentario(nomeUsuario: String, comentario: String, quantidadeCurtidas: int, quantidadeDecurtidas: int):
	_nomeUsuarioComentario.text = nomeUsuario
	_comentarioLabel.text = comentario
	_curtirBotao.text = str(quantidadeCurtidas)
	_descurtirBotao.text = str(quantidadeDecurtidas)
