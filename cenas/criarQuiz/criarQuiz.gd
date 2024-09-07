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
	var quiz = Quizzes.new().instanciaEntidade(tituloQuiz.text, botaoToggleIsPrivado.obterValorSelecionado(), classificacaoIndicativa.get_selected_id(), SessaoUsuario.usuarioLogado.idUsuario)
	var erroAoInserir = false
	
	BD.comecaTransacao()
	#Retorna o id do quiz inserido
	var responseQuiz  = BD.inserirDados(EntidadeConstantes.QuizzesTabela, quiz)
	
	if(responseQuiz):
		#Pega os filhos do container de perguntas
		var perguntas = perguntasContainer.get_children()
		
		#Percorre todos as perguntas
		for pergunta in perguntas:
			var idQuiz = responseQuiz
			pergunta = pergunta as ContainerPerguntaQuiz
			var perguntaAInserir = Perguntas.new().instanciaEntidade(pergunta.conteudoPergunta, idQuiz)
			var responsePergunta = BD.inserirDados(EntidadeConstantes.PerguntasTabela, perguntaAInserir)
			
			if(responsePergunta):
				#TODO: Inserir as alternativas
				pass
			else:
				erroAoInserir = true
	else: 
		erroAoInserir = true
		
	BD.finalizaTransacao()
			
	verificarResponse(erroAoInserir)


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
