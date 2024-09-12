extends PopUpBase
class_name PopUpFormPergunta

#Modal
var titulo: String
var conteudoPergunta: String
var textoBotaoFechar: String

@onready var popUp: Panel = $PopUp

#Modal
@onready var tituloLabel = $PopUp/ContainerVertical/Titulo
@onready var fecharBotao = $PopUp/ContainerVertical/MarginForm/Form/Alternativas/RodapeBotoes/Fechar
@onready var salvarBotao = $PopUp/ContainerVertical/MarginForm/Form/Alternativas/RodapeBotoes/Salvar

#Pergunta
@onready var perguntaConteudoInput := $PopUp/ContainerVertical/MarginForm/Form/PerguntaConteudo as TextEdit
var componenteCardPergunta: ContainerPerguntaQuiz
var idPergunta: int = 0

#Alternativas
@onready var inserirNovaAlternativaBotao = $PopUp/ContainerVertical/MarginForm/Form/Alternativas/HeaderAlternativas/InserirNovaAlternativa
@onready var alternativasContainer = $PopUp/ContainerVertical/MarginForm/Form/Alternativas/AlternativasContainer
var alternativasConteudoSalvas: Array
const alternativaComponente = preload("res://componentes/containerAlternativaFormQuiz/containerAlternativaFormQuiz.tscn")

#Temas alternativas
const _temaAlternativaIncorreto = preload("res://componentes/containerAlternativaFormQuiz/containerAlternativaIncorretaFormQuizTema.tres")
const _temaAlternativaCorreta = preload("res://componentes/containerAlternativaFormQuiz/containerAlternativaCorretaFormQuizTema.tres")


func _ready() -> void:
	popUp.scale = Vector2(0,0)
	
	#Sinais
	fecharBotao.connect("pressed", fechaPopup.bind(false))
	salvarBotao.connect("pressed", fechaPopup.bind(true))
	inserirNovaAlternativaBotao.connect("pressed", inserirNovaAlternativa)
	
	#Verifica se existem dados salvos alteriormente
	if(componenteCardPergunta != null):
		conteudoPergunta = componenteCardPergunta.conteudoPergunta
		alternativasConteudoSalvas = componenteCardPergunta.alternativasConteudoSalvas
		
	#Cria as alternativas
	criaAlternativasDefaultOuSalvas()
	
	#Insere os parametros
	tituloLabel.text = titulo
	fecharBotao.text = "Cancelar"
	perguntaConteudoInput.text = conteudoPergunta
	
	
func animaEntrada():
	var tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	tween.tween_property(popUp, "scale", Vector2(1.15,1.15), 0.3)
	tween.tween_property(popUp, "scale", Vector2(1,1), 0.2)
	await tween.finished


func fechaPopup(salvar: bool):
	var tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	tween.tween_property(popUp, "scale", Vector2(1.1,1.1), 0.2)
	tween.tween_property(popUp, "scale", Vector2(0,0), 0.3)
	await tween.finished
	
	if(salvar and componenteCardPergunta):
		componenteCardPergunta.conteudoPergunta = perguntaConteudoInput.text
		componenteCardPergunta.alternativasConteudoSalvas = alternativasContainer.get_children().map(
			func(value: ContainerAlternativaFormQuiz): 
				return {"conteudoAlternativa" : value.conteudoAlternativaTexto, "isAlternativaCorreta": value.isAlternativaCorreta, "alternativaId": value.alternativaId})
	self.queue_free()


#Cria as alternativas, sendo defaut ou as salvas
func criaAlternativasDefaultOuSalvas():
	var quantidadeAInserir = ConstantesPadroes.MINIMO_ALTERNATIVA_PERGUNTA if !alternativasConteudoSalvas else alternativasConteudoSalvas.size()
	
	for i in quantidadeAInserir:
		var alternativa = alternativaComponente.instantiate()
		alternativa.conteudoAlternativaTexto = "" if !alternativasConteudoSalvas else alternativasConteudoSalvas[i]["conteudoAlternativa"]
		
		alternativa.alternativaId = 0 if !alternativasConteudoSalvas or !alternativasConteudoSalvas[i].has("alternativaId") else alternativasConteudoSalvas[i]["alternativaId"]
		alternativasContainer.add_child(alternativa)
		
		
func inserirNovaAlternativa():
	#Verifica quantidade máxima de alternativas
	if(get_tree().get_nodes_in_group("alternativa").size() >= ConstantesPadroes.MAXIMO_ALTERNATIVA_PERGUNTA):
		PopUp.criaPopupNotificacao("Uma pergunta pode ter no máximo 4 alternativas")
		return
		
	var alternativa = alternativaComponente.instantiate()
	alternativasContainer.add_child(alternativa)
	

func _on_gui_input(event: InputEvent) -> void:
	if(event.is_action_pressed("CliqueDireito")):
		fechaPopup(false)
