extends PanelContainer
class_name CardBase

@onready var _jogaTwitchBotao = $ItensCard/BtJogarTwitch
@onready var _jogarBotao = $ItensCard/BtJogar

@onready var _criadorLabel = $ItensCard/CriadoPor/Criador
@onready var _tituloLabel = $ItensCard/Titulo
@onready var _categoriaLabel = $ItensCard/CategoriaPanel/CategoriaTexto
@onready var _favoritarEDenunciarContainer := $ItensCard/ImgCapaQuiz/FavoritarEDenunciar
@onready var _imagemCapaQuizContainer = $ItensCard/ImgCapaQuiz

var criador: String = ""
var titulo: String = ""

var quizId := 0
var usuarioId := 0

var thread: Thread
var terminouThread = false


func _process(_delta):
	if terminouThread:
		thread.wait_to_finish()
		terminouThread = false
		

func _ready():
	thread = Thread.new()
	
	_jogarBotao.connect("pressed", responderQuiz)
	_jogaTwitchBotao.connect("pressed", responderQuizTwitch)
	
	_criadorLabel.text = str(criador)
	_tituloLabel.text = str(titulo)
	
	_favoritarEDenunciarContainer.setaQuizFavoritado(quizId)
	
	#_inserirImagemDeCapaNoQuiz()
	thread.start(_inserirImagemDeCapaNoQuiz)


func _inserirImagemDeCapaNoQuiz():
	#InserirImagens
	var diretorioImagens = ConstantesPadroes.DIRETORIO_IMAGEMS_QUIZZES
	if usuarioId != 0 and quizId != 0:
		if DirAccess.dir_exists_absolute(diretorioImagens):
			var diretorioDaImagemDoQuiz = diretorioImagens + str(usuarioId) + "/" + str(quizId)

			var arquivosNoDiretorio = DirAccess.get_files_at(diretorioDaImagemDoQuiz)
			var arrayArquivos = Array(arquivosNoDiretorio)

			if arrayArquivos.size() > 0:
				var arquivoCaminho = diretorioDaImagemDoQuiz + "/" + arrayArquivos[0]			
				var image = Image.new()
				var texture = ImageTexture.new()
				image.load(ProjectSettings.globalize_path(arquivoCaminho))
				texture.set_image(image)
				_imagemCapaQuizContainer.call_deferred("set_texture", texture)
				
	terminouThread = true
	
					
func responderQuiz():
	TransicaoCena.trocar_cena(TransicaoCena.telaResponderQuiz, 0, quizId)


func responderQuizTwitch():
	TransicaoCena.trocar_cena(TransicaoCena.telaResponderQuizTwitch, 0, quizId)


func inserirCategoria(categoria: String):
	_categoriaLabel.text = categoria
