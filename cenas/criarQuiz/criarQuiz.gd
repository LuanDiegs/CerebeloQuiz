extends Control
class_name CriarQuiz

const perguntaQuizCardComponente = preload("res://componentes/containerPerguntaCriacaoQuiz/containerPerguntaCriacaoQuiz.tscn")

@onready var adicionarPerguntaBotao: Button = $Perguntas/HeaderPerguntas/Titulo/AdicionarPergunta
@onready var perguntasContainer: VBoxContainer = $Perguntas/PerguntasScrollContainer/PerguntasContainer

#Formulario salvar quiz
@onready var salvarQuizBotao := $FormularioInicial/Salvar
@onready var tituloQuiz := $FormularioInicial/TituloQuiz
@onready var botaoToggleIsPrivado := $FormularioInicial/BotaoToggle as BotaoToggle
@onready var classificacaoIndicativa := $FormularioInicial/ClassificacaoIndicativa as OptionButton
var thread: Thread

var retornou = false
var responseInsercao = false
var popUpSalvando: PopUpNotificacao


func _process(delta):
	if(retornou):
		retornou = false
		responseInsercao = false
		verificarResponse(responseInsercao)


func _ready() -> void:
	thread = Thread.new()
	adicionarPerguntaBotao.connect("pressed", criarPergunta)
	salvarQuizBotao.connect("pressed", salvarQuiz)


func salvarQuiz() -> void:
	if(validaFormulario()):
		var quiz = Quizzes.new().instanciaEntidade(tituloQuiz.text, botaoToggleIsPrivado.obterValorSelecionado(), classificacaoIndicativa.get_selected_id(), SessaoUsuario.usuarioLogado.idUsuario)
		var perguntas = perguntasContainer.get_children() as Array[ContainerPerguntaQuiz]
		
		popUpSalvando = PopUp.criaPopupNotificacao("Salvando seu quiz...", "", "Salvando...", true) as PopUpNotificacao
		thread.start(criarQuizAlgoritmo.bind(quiz, perguntas))
		

func criarQuizAlgoritmo(quiz, perguntas):
	var erroAoInserir = false
	
	#Insercao do quiz, retornando o id criado
	var responseQuiz  = BD.inserirQuiz(quiz, perguntas)
	
	if(!responseQuiz):
		erroAoInserir = true
	
	retornou = true
	responseInsercao = erroAoInserir


func validaFormulario():
	var mensagem = ""
	var valido = true
	var perguntasComConteudoVazio = perguntasContainer.get_children().map(getPerguntasComConteudoVazio)
	
	if(tituloQuiz.text.is_empty()):
		valido = false
		mensagem = "O título do quiz não foi inserido"
	
	if(valido):
		mensagem = "As seguintes perguntas estão com o conteúdo vazio: \n"
		for i in perguntasComConteudoVazio.size():
			if(perguntasComConteudoVazio[i]):
				valido = false
				mensagem = mensagem + str(perguntasComConteudoVazio[i]) + ", "
			
		#Remove a última vírgula e coloca um ponto
		mensagem = mensagem.left(mensagem.length()-2) + "." if !valido else ""
	
	if(valido):
		var alternativasComProblemas = perguntasContainer.get_children().map(getAlternativasComConteudoVazio)
		mensagem = "As alternativas dos seguintes quizzes estão inválidas: \n"
		for i in alternativasComProblemas.size():
			if(alternativasComProblemas[i]):
				valido = false
				mensagem = mensagem + str(alternativasComProblemas[i]) + ", "
			
		#Remove a última vírgula e coloca um ponto
		mensagem = mensagem.left(mensagem.length()-2) + "." if !valido else ""
	if(!mensagem.is_empty()):
		PopUp.criaPopupNotificacao(mensagem)
	
	return valido


func criarPergunta() -> void:
	if(perguntasContainer.get_children().size() < ConstantesPadroes.MAXIMO_PERGUNTAS_QUIZ):
		var perguntaCard = perguntaQuizCardComponente.instantiate()
		perguntasContainer.add_child(perguntaCard)
	else:
		var mensagemMaximoPerguntas = "Um quiz pode ter no máximo " + str(ConstantesPadroes.MAXIMO_PERGUNTAS_QUIZ) + " perguntas"
		PopUp.criaPopupNotificacao(mensagemMaximoPerguntas)


func verificarResponse(erroAoInserir: bool):
	var mensagem = "Ocorreu um erro ao salvar o quiz" if erroAoInserir else "Quiz criado com sucesso!"
	
	#Fecha a thread
	thread.wait_to_finish()
	
	#Remove o popup de salvando
	if(popUpSalvando):
		popUpSalvando.queue_free()
			
	#TODO: Criar tela de meus quizzes e redirecionar apos salvar corretamente
	var redirecionamento = "" if erroAoInserir else "meusQuizzes"
	PopUp.criaPopupNotificacao(mensagem)


func getPerguntasComConteudoVazio(pergunta: ContainerPerguntaQuiz):
	if !pergunta.conteudoPergunta or pergunta.conteudoPergunta.is_empty(): 
		return str(pergunta.get_index() + 1)
	
	return null


func getAlternativasComConteudoVazio(pergunta: ContainerPerguntaQuiz):
	var alternativas = pergunta.alternativasConteudoSalvas.map(func(value): return value[0] == "")
	var alternativasInvalidas = alternativas.has(true)
	
	if alternativasInvalidas: 
		return str(pergunta.get_index() + 1)
	
	return null


func _exit_tree():
	thread.wait_to_finish()
