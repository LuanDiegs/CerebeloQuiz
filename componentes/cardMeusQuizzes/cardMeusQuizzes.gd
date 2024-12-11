extends PanelContainer
class_name CardMeusQuizzes

var quizId := 0
var tituloDoQuiz := ""
var isDesativado := false

#Propriedades
@onready var _tituloQuiz = $MarginDentroDoPanel/Elementos/ContainerTextos/TituloQuiz
@onready var _avisoLabel = $MarginDentroDoPanel/Elementos/ContainerTextos/Aviso
@onready var _categoriaLabel = $MarginDentroDoPanel/Elementos/ContainerTextos/CategoriaPainel/CategoriaLabel

#Botões
@onready var _editarBotao = $MarginDentroDoPanel/Elementos/BotoesContainer/Editar
@onready var _deletarBotao = $MarginDentroDoPanel/Elementos/BotoesContainer/Deletar

#Imagem
@onready var _imagemDoQuiz = $MarginDentroDoPanel/Elementos/ImagemDoQuiz


var thread: Thread
var terminouThread = false


func _process(_delta):
	if terminouThread:
		thread.wait_to_finish()
		terminouThread = false
		
		
func _ready():
	thread = Thread.new()
	_editarBotao.connect("pressed", _editarQuiz)
	_deletarBotao.connect("pressed", _deletarQuiz)
	_tituloQuiz.text = tituloDoQuiz
	_avisoLabel.visible = isDesativado
	thread.start(_insereImagemQuiz)


func _insereImagemQuiz():
	var diretorioImagens = ConstantesPadroes.DIRETORIO_IMAGEMS_QUIZZES + str(SessaoUsuario.usuarioLogado.idUsuario) + "/" + str(quizId)
	if DirAccess.dir_exists_absolute(diretorioImagens):
		var arquivosNoDiretorio = DirAccess.get_files_at(diretorioImagens)
		var arrayArquivos = Array(arquivosNoDiretorio)

		if arrayArquivos.size() > 0:
			var arquivoCaminho = diretorioImagens + "/" + arrayArquivos[0]
			var image = Image.new()
			var texture = ImageTexture.new()
			image.load(ProjectSettings.globalize_path(arquivoCaminho))			
			texture.set_image(image)
			_imagemDoQuiz.call_deferred("set_texture", texture)
	
	terminouThread = true
	
			
func _editarQuiz():
	TransicaoCena.trocar_cena(TransicaoCena.telaEditFormQuiz, quizId)
	
	
func _deletarQuiz():
	PopUp.criaPopupConfirmacao(
		"Certeza que deseja deletar o quiz " + tituloDoQuiz,
		"Atenção",
		"Cancelar",
		[Utils.criaBotaoAdicional("Confirmar", _deletarQuizBanco)]
	)

func _deletarQuizBanco():
	if(Quizzes.new().deletarDado(EntidadeConstantes.QuizzesTabela, "quizId = " + str(quizId))):
		var cena = get_tree().current_scene as MeusQuizzes
		cena.atualizarGridMeusQuizzes()
		
		PopUp.criaPopupNotificacao("O Quiz foi excluído com sucesso!", "", "Sucesso")
		

func inserirCategoria(categoria: String):
	pass
	#_categoriaLabel.text = categoria
