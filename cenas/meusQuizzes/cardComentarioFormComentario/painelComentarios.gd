extends PanelContainer
class_name CardComentario

@onready var _autorLabel = $MarginItens/ItensComentarios/Header/Autor
@onready var _comentarioLabel = $MarginItens/ItensComentarios/Comentario
@onready var _fixadoIcon = $MarginItens/ItensComentarios/Header/Fixado

@onready var _fixarComentarioBotao = $MarginItens/ItensComentarios/Header/FixarComentario

var _comentarioId = 0
var _perguntaId = 0

signal fixouComentario

func _ready():
	_fixarComentarioBotao.connect("pressed", _fixarComentario)
	

func inserePropriedadesDoComponente(
	comentarioId: int, 
	perguntaId: int,
	autor: String, 
	comentario: String, 
	isFixado: bool
):
	_autorLabel.text = autor
	_comentarioLabel.text = comentario
	_comentarioId = comentarioId
	_perguntaId = perguntaId
	
	_fixadoIcon.visible = isFixado
	_fixarComentarioBotao.disabled = isFixado


func _fixarComentario():
	PopUp.criaPopupConfirmacao(
		"Certeza que deseja fixar esse comentário?",
		"Confirmar",
		"Fechar",
		[Utils.criaBotaoAdicional("Confirmar", _fixarComentarioAlgoritmo)])
	

func _fixarComentarioAlgoritmo():
	var response = Comentario.new().fixaComentario(_comentarioId, _perguntaId)
	var mensagem = "Comentário fixado com sucesso!" if response else "Ocorreu um erro na hora de fixar deu comentário :("
	
	PopUp.criaPopupNotificacao(mensagem)
	
	if response:
		fixouComentario.emit()
