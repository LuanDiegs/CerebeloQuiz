extends Panel
class_name Sidebar

@onready var _loginBotao = $SessaoDeLogin/ContainerSessaoLogin/Login
@onready var _perfilBotao = $SessaoDeUsuario/ContainerUsuario/Perfil
@onready var _iconBotaoCriarQuiz = $SessaoCentral/SessaoCentral/BotaoCriarQuiz/CriarQuiz/IconBotaoCriarQuiz

@onready var _versaoSoftware: Label = $SessaoCentral/VersaoSoftware

@onready var _meusQuizesBotao: BotaoMenuSidebar = $SessaoCentral/SessaoCentral/ContainerBotoesCentrais/VBoxBotoesCentrais/MeusQuizes
@onready var _criarQuizBotao: BotaoCriarQuizz = $SessaoCentral/SessaoCentral/BotaoCriarQuiz/CriarQuiz

func _ready() -> void:
	_versaoSoftware.text = "Versão " + ProjectSettings.get_setting("application/config/version")


func _process(delta):
	verificaSessao()


func verificaSessao():
	if(SessaoUsuario.isLogada):
		_perfilBotao.text = SessaoUsuario.usuarioLogado.nomeUsuario
		_loginBotao.text = "DESLOGAR"
		
		_criarQuizBotao.visible = true
		_iconBotaoCriarQuiz.visible = true
		
		_perfilBotao.redirecionarPara = ""
		_meusQuizesBotao.redirecionarPara = "res://cenas/meusQuizzes/meusQuizzes.tscn"
	else:
		_perfilBotao.text = "DESLOGADO!"
		_loginBotao.text = "LOGIN"
		
		_criarQuizBotao.visible = false
		_iconBotaoCriarQuiz.visible = false
		
		_meusQuizesBotao.redirecionarPara = "res://cenas/login/login.tscn"
