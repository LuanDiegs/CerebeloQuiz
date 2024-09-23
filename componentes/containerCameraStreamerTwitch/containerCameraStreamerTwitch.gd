extends PanelContainer
class_name ContainerCameraStreamerTwitch

@onready var _alternativasContainer = $StreamerAlternativasVBox
@onready var _mensagemContainer = $StreamerAlternativasMensagem
@onready var _alternativaBaseBotao = $StreamerAlternativasVBox/StreamerAlternativaBase

signal selecionouAlternativa(acertou: bool)

func trocarConteudoContainer(alternativas: Array, isShowingPergunta: bool = false):
	if isShowingPergunta:
		#Remove alternativas anteriores
		removeAlternativasPerguntaAnterior()
		
		for i in range(alternativas.size()):
			var botaoAlternativa = _alternativaBaseBotao.duplicate() as BotaoAlternativaStreamer
			botaoAlternativa.isAlternativaCorreta = alternativas[i]["isAlternativaCorreta"]
			botaoAlternativa.text = "Alternativa " + str(i+1)
			botaoAlternativa.visible = true
			
			_alternativasContainer.add_child(botaoAlternativa)
			
	_alternativasContainer.visible = isShowingPergunta
	_mensagemContainer.visible = !isShowingPergunta
	
	
func removeAlternativasPerguntaAnterior():
	for i in range(_alternativasContainer.get_child_count()):
		#Se for 0 significa que é a alternativa base
		if i == 0:
			continue
		
		_alternativasContainer.get_child(i).queue_free()


func desabilitaAlternativas(acertou: bool):
	for i in range(_alternativasContainer.get_child_count()):
		#Se for 0 significa que é a alternativa base
		if i == 0:
			continue
		var botao = _alternativasContainer.get_child(i) as BotaoAlternativaStreamer
		_alternativasContainer.get_child(i).disabled = true
	
	selecionouAlternativa.emit(acertou)
