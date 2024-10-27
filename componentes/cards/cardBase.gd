extends PanelContainer
class_name CardBase

@onready var _jogaTwitchBotao = $ItensCard/BtJogarTwitch
@onready var _jogarBotao = $ItensCard/BtJogar

@onready var _criadorLabel = $ItensCard/CriadoPor/Criador
@onready var _tituloLabel = $ItensCard/Titulo
@onready var _favoritarEDenunciarContainer := $ItensCard/ImgCapaQuiz/FavoritarEDenunciar
@onready var _imagemCapaQuizContainer = $ItensCard/ImgCapaQuiz

var criador: String = ""
var titulo: String = ""

var quizId := 0

func _ready():
	_jogarBotao.connect("pressed", responderQuiz)
	_jogaTwitchBotao.connect("pressed", responderQuizTwitch)
	
	_criadorLabel.text = str(criador)
	_tituloLabel.text = str(titulo)
	
	_favoritarEDenunciarContainer.setaQuizFavoritado(quizId)
	
	#InserirImagens
	var diretorioImagens = ConstantesPadroes.DIRETORIO_IMAGEMS_QUIZZES
	if DirAccess.dir_exists_absolute(diretorioImagens):
		var diretoriosDosUsuarios = DirAccess.get_directories_at(diretorioImagens)
		for diretorioUsuario in diretoriosDosUsuarios:
			var diretorioImagenDoQuiz = diretorioImagens + diretorioUsuario + "/" + str(quizId)
			if DirAccess.dir_exists_absolute(diretorioImagenDoQuiz):
				var arquivosNoDiretorio = DirAccess.get_files_at(diretorioImagenDoQuiz)
				var arrayArquivos = Array(arquivosNoDiretorio)
				
				if arrayArquivos.size() > 0:
					var arquivoCaminho = diretorioImagenDoQuiz + "/" + arrayArquivos[0]			
					var image = Image.new()
					var texture = ImageTexture.new()
					image.load(ProjectSettings.globalize_path(arquivoCaminho))
					texture.set_image(image)
					_imagemCapaQuizContainer.texture = texture
				

func responderQuiz():
	TransicaoCena.trocar_cena(TransicaoCena.telaResponderQuiz, 0, quizId)


func responderQuizTwitch():
	TransicaoCena.trocar_cena(TransicaoCena.telaResponderQuizTwitch, 0, quizId)
