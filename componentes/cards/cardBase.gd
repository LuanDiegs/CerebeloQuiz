extends PanelContainer
class_name CardBase

@onready var _jogaTwitchBotao = $ItensCard/BtJogarTwitch
@onready var _jogarBotao = $ItensCard/BtJogar

@onready var _criadorLabel = $ItensCard/CriadoPor/Criador
@onready var _tituloLabel = $ItensCard/Titulo
@onready var _favoritarEDenunciarContainer := $ItensCard/ImgCapaQuiz/FavoritarEDenunciar

var criador: String = ""
var titulo: String = ""

var quizId := 0


func _ready():
	_jogarBotao.connect("pressed", responderQuizTeste)
	_jogaTwitchBotao.connect("pressed", responderQuizTwitchTeste)
	
	_criadorLabel.text = str(criador)
	_tituloLabel.text = str(titulo)
	
	_favoritarEDenunciarContainer.setaQuizFavoritado(quizId)


func responderQuizTeste():
	TransicaoCena.trocar_cena(TransicaoCena.telaResponderQuiz, 0, quizId)


func responderQuizTwitchTeste():
	TransicaoCena.trocar_cena(TransicaoCena.telaResponderQuizTwitch, 0, quizId)
