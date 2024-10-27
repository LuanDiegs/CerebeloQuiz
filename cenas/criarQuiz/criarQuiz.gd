extends Control
class_name CriarQuiz

const perguntaQuizCardComponente = preload("res://componentes/containerPerguntaCriacaoQuiz/containerPerguntaCriacaoQuiz.tscn")

@onready var _adicionarPerguntaBotao: Button = $Perguntas/HeaderPerguntas/Titulo/AdicionarPergunta
@onready var _perguntasContainer: VBoxContainer = $Perguntas/PerguntasScrollContainer/PerguntasContainer
@onready var _labelSemPerguntas = $Perguntas/PerguntasScrollContainer/LabelSemPerguntas

#Formulario salvar quiz
@onready var salvarQuizBotao := $FormularioInicial/Salvar
@onready var tituloQuiz := $FormularioInicial/TituloQuiz
@onready var botaoToggleIsPrivado := $FormularioInicial/BotaoToggle as BotaoToggle
@onready var classificacaoIndicativa := $FormularioInicial/ClassificacaoIndicativa as OptionButton
@onready var imagemDoQuizBotao = $"FormularioInicial/InputInserirImagem/InserirImagem"

var thread: Thread

#Propriedades para abrir o modal de inserção
var retornou = false
var responseInsercao = false
var popUpSalvando: PopUpNotificacao

#Edicao ou inserção
@export var idRegistroEdicao: int = 0
var quizSalvo

#Salvas
var perguntasDoBancoQuiz: Dictionary

func _process(delta):
	#Verifica se tem alguma pergunta para exibir a mensagem
	_labelSemPerguntas.visible = true if _perguntasContainer.get_child_count() == 0 else false
	
	if (retornou):
		retornou = false
		responseInsercao = false
		verificarResponse(responseInsercao)


func _ready() -> void:
	thread = Thread.new()
	_adicionarPerguntaBotao.connect("pressed", criarPergunta)
	salvarQuizBotao.connect("pressed", salvarQuiz)
	
	#Se o quiz tiver um id significa que ele já existe
	if (idRegistroEdicao != 0):
		quizSalvo = Quizzes.new().getQuizCompleto(idRegistroEdicao)
		preencheDadosDoQuizSalvo()


func preencheDadosDoQuizSalvo():
	#Quiz
	tituloQuiz.text = quizSalvo.titulo
	botaoToggleIsPrivado.insereValor(quizSalvo.isPrivado)
	classificacaoIndicativa.selected = quizSalvo.classificacaoIndicativa - 1 # -1 pois a gente salva o ID e não o selecionado
	
	#Perguntas
	criarPerguntasSalvas()
	
	#Imagem
	inserirImagemSalva()


func criarPerguntasSalvas():
	var perguntas = quizSalvo.perguntas
	
	#Deleta todas as perguntas default	
	for n in _perguntasContainer.get_children():
		_perguntasContainer.remove_child(n)
	
	#Insere as perguntas
	for pergunta in perguntas:
		perguntasDoBancoQuiz.get_or_add(pergunta.perguntaId, pergunta)
		
		var perguntaCard = perguntaQuizCardComponente.instantiate() as ContainerPerguntaQuiz
		perguntaCard.idPergunta = pergunta.perguntaId
		perguntaCard.conteudoPergunta = pergunta.conteudoPergunta
		
		#Alternativas
		perguntaCard.alternativasConteudoSalvas = pergunta.alternativas
		_perguntasContainer.add_child(perguntaCard)
	
		
func inserirImagemSalva():
	var diretorioImagens = ConstantesPadroes.DIRETORIO_IMAGEMS_QUIZZES + str(SessaoUsuario.usuarioLogado.idUsuario) + "/" + str(idRegistroEdicao)
	if DirAccess.dir_exists_absolute(diretorioImagens):
		var arquivosNoDiretorio = DirAccess.get_files_at(diretorioImagens)
		var arrayArquivos = Array(arquivosNoDiretorio)

		if arrayArquivos.size() > 0:
			var arquivoCaminho = diretorioImagens + "/" + arrayArquivos[0]
			var image = Image.new()
			var texture = ImageTexture.new()	
			image.load(ProjectSettings.globalize_path(arquivoCaminho))
			texture.set_image(image)
			imagemDoQuizBotao.texture = texture
		

func salvarQuiz() -> void:
	if (validaFormulario()):
		var quiz = Quizzes.new().instanciaEntidade(tituloQuiz.text, botaoToggleIsPrivado.obterValorSelecionado(), classificacaoIndicativa.get_selected_id(), SessaoUsuario.usuarioLogado.idUsuario)
		var perguntas = _perguntasContainer.get_children() as Array[ContainerPerguntaQuiz]
		var imagemExtensao = imagemDoQuizBotao.extensaoDaImagem
		var imagem = imagemDoQuizBotao.imagemDoQuiz
		
		popUpSalvando = PopUp.criaPopupNotificacao("Salvando seu quiz...", "", "Salvando...", true) as PopUpNotificacao
		thread.start(salvarQuizAlgoritmo.bind(quiz, perguntas, imagemExtensao, imagem))
		

func salvarQuizAlgoritmo(quiz, perguntas, imagemExtensao, imagem):
	var erroAoInserir = false
	
	#Insercao ou edição do quiz, retornando o id criado
	var responseQuiz
	if (idRegistroEdicao == 0):
		responseQuiz = Quizzes.new().inserirQuiz(quiz, perguntas, imagemExtensao, imagem)
	else:
		responseQuiz = Quizzes.new().editarInserirQuiz(
			idRegistroEdicao,
			quiz,
			perguntasDoBancoQuiz,
			perguntas,
			imagemExtensao,
			imagem)
		
	if (!responseQuiz):
		erroAoInserir = true
	
	retornou = true
	responseInsercao = erroAoInserir


func validaFormulario():
	var mensagem = ""
	var valido = true
	var perguntasComConteudoVazio = _perguntasContainer.get_children().map(getPerguntasComConteudoVazio)
	
	if (tituloQuiz.text.is_empty()):
		valido = false
		mensagem = "O título do quiz não foi inserido"
	
	if (valido):
		mensagem = "As seguintes perguntas estão com o conteúdo vazio: \n"
		for i in perguntasComConteudoVazio.size():
			if (perguntasComConteudoVazio[i]):
				valido = false
				mensagem = mensagem + str(perguntasComConteudoVazio[i]) + ", "
			
		#Remove a última vírgula e coloca um ponto
		mensagem = mensagem.left(mensagem.length() - 2) + "." if !valido else ""
	
	#Necessário salvar pelo menos 1 pergunta
	if (valido):
		var alternativas = _perguntasContainer.get_children()
		if (!alternativas):
			valido = false
			mensagem = "É necessário inserir pelo menos 1 pergunta."
		
		
	if (valido):
		var alternativasComProblemas = _perguntasContainer.get_children().map(getAlternativasComConteudoVazio)
		mensagem = "As alternativas dos seguintes quizzes estão inválidas: \n"
		
		for i in alternativasComProblemas.size():
			if (alternativasComProblemas[i]):
				valido = false
				mensagem = mensagem + str(alternativasComProblemas[i]) + ", "
			
		#Remove a última vírgula e coloca um ponto
		mensagem = mensagem.left(mensagem.length() - 2) + "." if !valido else ""
		
	if (!mensagem.is_empty()):
		PopUp.criaPopupNotificacao(mensagem)
	
	return valido


func criarPergunta() -> void:
	if (_perguntasContainer.get_children().size() < ConstantesPadroes.MAXIMO_PERGUNTAS_QUIZ):
		var perguntaCard = perguntaQuizCardComponente.instantiate()
		_perguntasContainer.add_child(perguntaCard)
	else:
		var mensagemMaximoPerguntas = "Um quiz pode ter no máximo " + str(ConstantesPadroes.MAXIMO_PERGUNTAS_QUIZ) + " perguntas"
		PopUp.criaPopupNotificacao(mensagemMaximoPerguntas)


func verificarResponse(erroAoInserir: bool):
	var mensagemCriacaoEdicao = "Quiz criado com sucesso!" if idRegistroEdicao == 0 else "Quiz editado com sucesso!"
	var mensagem = "Ocorreu um erro ao salvar o quiz" if erroAoInserir else mensagemCriacaoEdicao
	
	#Fecha a thread
	thread.wait_to_finish()
	
	#Remove o popup de salvando
	if (popUpSalvando):
		popUpSalvando.queue_free()
	
	#Mostra o popup e redireciona para a tela de meus quizzes
	var redirecionamento = "" if erroAoInserir else TransicaoCena.telaMeusQuizzes
	PopUp.criaPopupNotificacao(mensagem, redirecionamento)


func getPerguntasComConteudoVazio(pergunta: ContainerPerguntaQuiz):
	if !pergunta.conteudoPergunta or pergunta.conteudoPergunta.is_empty():
		return str(pergunta.get_index() + 1)
	
	return null


func getAlternativasComConteudoVazio(pergunta: ContainerPerguntaQuiz):
	var alternativas = pergunta.alternativasConteudoSalvas.map(func(value): return value["conteudoAlternativa"] == "")
	var alternativasInvalidas = alternativas.has(true)
	
	if alternativasInvalidas:
		return str(pergunta.get_index() + 1)
	
	return null


func _exit_tree():
	if (thread.is_alive()):
		thread.wait_to_finish()
