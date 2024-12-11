extends Panel
class_name Sidebar

@onready var _loginBotao = $Itens/SessaoDeLogin/ContainerSessaoLogin/Login/Login
@onready var _perfilBotao = $Itens/SessaoDeUsuario/ContainerUsuario/Perfil/Perfil
@onready var _iconBotaoCriarQuiz = $Itens/SessaoCentral/SessaoCentral/BotaoCriarQuiz/CriarQuiz/IconBotaoCriarQuiz

@onready var _versaoSoftware: Label = $Itens/SessaoDeLogin/ContainerSessaoLogin/Login/VersaoSoftware

@onready var _meusQuizesBotao: BotaoMenuSidebar = $Itens/SessaoCentral/SessaoCentral/ContainerBotoesCentrais/VBoxBotoesCentrais/MeusQuizes
@onready var _criarQuizBotao: BotaoCriarQuizz = $Itens/SessaoCentral/SessaoCentral/BotaoCriarQuiz/CriarQuiz
@onready var _quizzesFavoritos = $Itens/SessaoCentral/SessaoCentral/ContainerBotoesCentrais/VBoxBotoesCentrais/QuizzesFavoritos

func _ready() -> void:
	_versaoSoftware.text = "Versão " + ProjectSettings.get_setting("application/config/version")


func _process(_delta):
	verificaSessao()


func verificaSessao():
	if(SessaoUsuario.isLogada):
		_perfilBotao.text = SessaoUsuario.usuarioLogado.nomeUsuario
		_loginBotao.text = "DESLOGAR"
		
		_criarQuizBotao.visible = true
		_iconBotaoCriarQuiz.visible = true
		
		_perfilBotao.redirecionarPara = "res://cenas/denuncias/denuncias.tscn" if SessaoUsuario.usuarioLogado.isModerador else ""
		_meusQuizesBotao.redirecionarPara = "res://cenas/meusQuizzes/meusQuizzes.tscn"
	else:
		_perfilBotao.text = "CRIAR CONTA!"
		_loginBotao.text = "LOGIN"
		
		_criarQuizBotao.visible = false
		_iconBotaoCriarQuiz.visible = false
		
		_meusQuizesBotao.redirecionarPara = "res://cenas/login/login.tscn"
		_perfilBotao.redirecionarPara = "res://cenas/cadastroUsuario/cadastroUsuario.tscn"
		_quizzesFavoritos.redirecionarPara = "res://cenas/login/login.tscn"
