extends HBoxContainer
class_name FavoritarEDenunciarContainer

@onready var _botaoDenuncia = $BotaoDenuncia
@onready var _botaoFavoritar = $BotaoFavoritar

var _isFavoritado := false
var quizId := 0
var _idQuizFavoritado := 0

const ICON_QUIZ_FAVORITADO = preload("res://resources/imagens/icons/estrela_c_preenchimento.png")
const ICON_QUIZ_DESFAVORITADO = preload("res://resources/imagens/icons/estrela_s_preenchimento.png")

func _ready():
	_botaoFavoritar.connect("pressed", _favoritarQuiz)


func _favoritarQuiz():	
	if !_isFavoritado:
		var response = Quizzes.new().favoritarQuiz(quizId)
		
		#Retorna o id do quizFavoritado
		if(response):
			_isFavoritado = true
			_idQuizFavoritado = response
	else:
		var response = Quizzes.new().desfavoritarQuiz(_idQuizFavoritado)
		
		if(response):
			_isFavoritado = false
			_idQuizFavoritado = 0
		
	await _animaClique()
	_setaIconesFavoritado(_isFavoritado)
	
	if(get_tree().current_scene is QuizzesFavoritos):
		var cena = get_tree().current_scene
		cena.atualizaQuizzes()


func setaQuizFavoritado(quizId):
	self.quizId = quizId
	
	var quizFavoritado = Quizzes.new().getQuizFavoritado(quizId)
	
	if(quizFavoritado):
		_isFavoritado = true
		_idQuizFavoritado = quizFavoritado[0].quizFavoritoId

	_setaIconesFavoritado(_isFavoritado)


func _setaIconesFavoritado(isFavoritado: bool):
	if !isFavoritado:
		_botaoFavoritar.texture_normal = ICON_QUIZ_DESFAVORITADO
	else:
		_botaoFavoritar.texture_normal = ICON_QUIZ_FAVORITADO


func _animaClique():
	var tween = create_tween().set_trans(Tween.TRANS_SINE)
	var tween2 = create_tween().set_trans(Tween.TRANS_SINE)
	_botaoFavoritar.pivot_offset = _botaoFavoritar.size/2
	tween.tween_property(_botaoFavoritar, "scale", Vector2(1.4, 1.4), 0.3)
	tween.tween_property(_botaoFavoritar, "scale", Vector2(1, 1), 0.3)
	tween2.tween_property(_botaoFavoritar, "rotation", deg_to_rad(-30), 0.3).as_relative()
	tween2.tween_property(_botaoFavoritar, "rotation", deg_to_rad(390), 0.4).as_relative()
	await tween.finished
