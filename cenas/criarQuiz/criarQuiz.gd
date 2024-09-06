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
	var quiz = Quizzes.new().instanciaEntidade(tituloQuiz.text, botaoToggleIsPrivado.obterValorSelecionado(), classificacaoIndicativa.get_selected_id(), SessaoUsuario.usuarioIdLogado)
	
	var response  = BD.inserirDados(EntidadeConstantes.QuizzesTabela, quiz)
	var mensagem = "Quiz criado com sucesso!" if response else "Ocorreu um erro ao salvar o quiz"
	
	#TODO: Criar tela de meus quizzes e redirecionar apos salvar corretamente
	var redirecionamento = "meusQuizzes" if response else null
	PopUp.criaPopupNotificacao(mensagem)


func criarPergunta() -> void:
	if(perguntasContainer.get_children().size() < ConstantesPadroes.MAXIMO_PERGUNTAS_QUIZ):
		var perguntaCard = perguntaQuizCardComponente.instantiate()
		perguntasContainer.add_child(perguntaCard)
	else:
		var mensagemMaximoPerguntas = "Um quiz pode ter no máximo " + str(ConstantesPadroes.MAXIMO_PERGUNTAS_QUIZ) + " perguntas"
		PopUp.criaPopupNotificacao(mensagemMaximoPerguntas)
