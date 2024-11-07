extends PanelContainer
class_name InserirComentarioPainel

@onready var _nomeUsuarioComentarioLabel = $Margin/Itens/NomeUsuarioComentario
@onready var _comentarBotao = $Margin/Itens/ComentarBotao

@onready var _comentarioInput = $Margin/Itens/Comentario
var _perguntaId = 0

signal inseriuComentario


func _ready():
	_comentarBotao.connect("pressed", _inserirComentario)
	_nomeUsuarioComentarioLabel.text = SessaoUsuario.usuarioLogado.nomeUsuario


func _inserirComentario():
	var comentarioClasse = Comentario.new()
	var response = comentarioClasse.inserirComentario(_comentarioInput.text, _perguntaId)
	var mensagem = "Comentário inserido com sucesso!" if response else "Ocorreu um erro ao inserir o comentário"
	
	PopUp.criaPopupNotificacao(mensagem)
	inseriuComentario.emit()
	_comentarioInput.clear()
	

func definePerguntaId(perguntaId: int):
	_perguntaId = perguntaId
