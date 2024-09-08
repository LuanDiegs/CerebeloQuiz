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


func _ready() -> void:
	adicionarPerguntaBotao.connect("pressed", criarPergunta)
	salvarQuizBotao.connect("pressed", salvarQuiz)
	
	
func salvarQuiz() -> void:
	print("oi")
	var erroAoInserir = false
	
	#Valida o formulario
	if(validaFormulario()):	
		#Insercao do quiz, retornando o id criado
		var quiz = Quizzes.new().instanciaEntidade(tituloQuiz.text, botaoToggleIsPrivado.obterValorSelecionado(), classificacaoIndicativa.get_selected_id(), SessaoUsuario.usuarioLogado.idUsuario)
		var responseQuiz  = BD.inserirDados(EntidadeConstantes.QuizzesTabela, quiz)
		
		if(responseQuiz):
			var perguntas = perguntasContainer.get_children() as Array[ContainerPerguntaQuiz]

			#Percorre todos as perguntas
			for pergunta in perguntas:
				var idQuiz = responseQuiz
				pergunta = pergunta as ContainerPerguntaQuiz
				var perguntaAInserir = Perguntas.new().instanciaEntidade(pergunta.conteudoPergunta, idQuiz)
				var responsePergunta = BD.inserirDados(EntidadeConstantes.PerguntasTabela, perguntaAInserir)
				
				if(responsePergunta):
					var alternativas = pergunta.alternativasConteudoSalvas
					
					for i in alternativas.size():
						var idPergunta = responsePergunta
						var alternativaAInserir = Alternativas.new().instanciaEntidade(alternativas[i][0], alternativas[i][1], idPergunta)
						var responseAlternativa = BD.inserirDados(EntidadeConstantes.AlternativasTabela, alternativaAInserir)
						
						if(!responseAlternativa):
							erroAoInserir = true
				else:
					erroAoInserir = true
		else: 
			erroAoInserir = true
				
		verificarResponse(erroAoInserir)


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
