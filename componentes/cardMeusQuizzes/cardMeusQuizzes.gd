extends PanelContainer
class_name CardMeusQuizzes

var quizId := 0
var tituloDoQuiz := ""

#Propriedades
@onready var _tituloQuiz = $MarginDentroDoPanel/Elementos/TituloQuiz

#Botões
@onready var _editarBotao = $MarginDentroDoPanel/Elementos/BotoesContainer/Editar
@onready var _deletarBotao = $MarginDentroDoPanel/Elementos/BotoesContainer/Deletar

#Imagem
@onready var _imagemDoQuiz = $MarginDentroDoPanel/Elementos/ImagemDoQuiz


func _ready():
	_editarBotao.connect("pressed", _editarQuiz)
	_deletarBotao.connect("pressed", _deletarQuiz)
	_tituloQuiz.text = tituloDoQuiz
	_insereImagemQuiz()


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
			_imagemDoQuiz.texture = texture
			
			
func _editarQuiz():
	TransicaoCena.trocar_cena(TransicaoCena.telaEditFormQuiz, quizId)
	
	
func _deletarQuiz():
	PopUp.criaPopupConfirmacao(
		"Certeza que deseja deletar o quiz " + tituloDoQuiz,
		"Atenção",
		"Cancelar",
		Utils.criaBotaoAdicional("Confirmar", _deletarQuizBanco)
	)

func _deletarQuizBanco():
	if(Quizzes.new().deletarDado(EntidadeConstantes.QuizzesTabela, "quizId = " + str(quizId))):
		var cena = get_tree().current_scene as MeusQuizzes
		cena.atualizarGridMeusQuizzes()
		
		PopUp.criaPopupNotificacao("O Quiz foi excluído com sucesso!", "", "Sucesso")
		
