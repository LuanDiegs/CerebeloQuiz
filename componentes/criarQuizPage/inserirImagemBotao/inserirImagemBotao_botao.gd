extends TextureRect
class_name InserirImagemBotao

@onready var _abrirArquivosBotao = $AbrirArquivosBotao
@onready var _arquivosFileDialog = $Arquivos
@onready var _imagemDoQuiz = $"."

var idQuiz = 0
var extensaoDaImagem = ""
var imagemDoQuiz: Image = null

func _ready():
	_abrirArquivosBotao.connect("pressed", _abrirArquivosImagem)
	get_tree().get_root().files_dropped.connect(_selecionarArquivoArrastando)


func _abrirArquivosImagem():
	_arquivosFileDialog.popup()
	pass


func _selecionarArquivo(path: String):
	if !_verificaExtensaoArquivo(path):
		return

	_setarImagemNoBotao(path)


func _selecionarArquivoArrastando(files):
	var path = files[0]
	if !_verificaExtensaoArquivo(path):
		return
		
	_setarImagemNoBotao(path)


func _verificaExtensaoArquivo(path):
	var extensao = path.get_extension()
	
	if extensao != "png" and extensao != "jpg" and extensao != "jpeg" and extensao != "webp":
		PopUp.criaPopupNotificacao("Somente são aceitos as extensões:\n.png, .jpg, .jpeg e .webp")
		return false
	return true


func _setarImagemNoBotao(path: String):
	var image = Image.new()
	var imageTexture = ImageTexture.new()
	
	var erro = image.load(path)
	if erro:
		PopUp.criaPopupNotificacao("Ocorreu um erro ao inserir a imagem :(")
		return
		
	imageTexture.set_image(image)
	_imagemDoQuiz.texture = imageTexture
	
	extensaoDaImagem = path.get_extension()
	imagemDoQuiz = image
