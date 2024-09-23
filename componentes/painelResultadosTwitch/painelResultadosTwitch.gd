extends PanelContainer
class_name PainelResultadosTwitch

@onready var resultadoClaroBase = $ScrollResultado/ListaResultados/ResultadoClaroBase
@onready var resultadoEscuroBase = $ScrollResultado/ListaResultados/ResultadoEscuroBase

@onready var _titulo = $ScrollResultado/ListaResultados/Titulo/Titulo
@onready var _listaResultados = $ScrollResultado/ListaResultados
@onready var _scrollResultado: ScrollContainer = $ScrollResultado
@onready var _scrollDoscrollResultado: VScrollBar = _scrollResultado.get_v_scroll_bar()
var isResultadoVisível := false

@onready var _delay := $Delay as Timer


func _ready():
	_delay.connect("timeout", comecaARolarOScroll)
	_scrollDoscrollResultado.connect("mouse_entered", func(): isResultadoVisível = false)
	_scrollDoscrollResultado.connect("mouse_exited", func(): isResultadoVisível = true)


func _process(delta):
	if isResultadoVisível and _scrollDoscrollResultado.value < _scrollDoscrollResultado.max_value:
		_scrollResultado.get_v_scroll_bar().value += 0.3


func comecaARolarOScroll():
	isResultadoVisível = true
	

func insereDadosNoPainelResultados(dados: Dictionary, isResultadoFinalPartida: bool = false):
	_delay.start()
	_scrollResultado.get_v_scroll_bar().value = _scrollResultado.get_v_scroll_bar().min_value
		
	_titulo.text = "RESULTADOS DA RODADA" if !isResultadoFinalPartida else "RESULTADOS DA PARTIDA"
	
	#Se tiver mais de 5 filhos significa que foram criados os cards já
	if _listaResultados.get_child_count() < 5:
		for i in range(20):
			var card = resultadoClaroBase.duplicate() if i % 2 == 0 else resultadoEscuroBase.duplicate()
			var posicao: String
			var nickname: String
			var pontuacao: String
			
			#Se existir coloca
			if dados.get(i):
				posicao = str(i+1)
				nickname = dados[i]["nickname"]
				pontuacao = str(dados[i]["pontuacao"])
			else:
				posicao = "-"
				nickname = "==="
				pontuacao = "-"
			
			var cardCompleto = _insereInformacoesCard(card, posicao, nickname, pontuacao)
			_listaResultados.add_child(cardCompleto)
	else:
		var cardsResultados: Array[PanelContainer]
		
		for card in _listaResultados.get_children():
			if card.is_in_group("cardPlacarResultadoTwitch"):
				cardsResultados.append(card)
			
		for i in cardsResultados.size():
			if(dados.get(i)):
				_insereInformacoesCard(cardsResultados[i], str(i+1), dados[i]["nickname"], str(dados[i]["pontuacao"]))


func _insereInformacoesCard(card: PanelContainer, colocacao: String, nickname: String, pontuacao: String) -> PanelContainer:
	card.get_child(0).get_child(0).text = str(colocacao)
	card.get_child(0).get_child(1).text = nickname
	card.get_child(0).get_child(2).text = str(pontuacao)
	card.add_to_group("cardPlacarResultadoTwitch")
	card.visible = true
	
	return card
