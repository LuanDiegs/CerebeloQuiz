extends Panel
class_name Sidebar

@onready var loginBotao = $SessaoDeLogin/ContainerSessaoLogin/Login
@onready var perfilBotao = $SessaoDeUsuario/ContainerUsuario/Perfil
@onready var criarQuizBotao: BotaoCriarQuizz = $SessaoCentral/SessaoCentral/BotaoCriarQuiz/CriarQuiz
@onready var iconBotaoCriarQuiz = $SessaoCentral/SessaoCentral/BotaoCriarQuiz/CriarQuiz/IconBotaoCriarQuiz

@onready var versao_software: Label = $SessaoCentral/VersaoSoftware

func _ready() -> void:
	versao_software.text = "Versão " + ProjectSettings.get_setting("application/config/version")


func _process(delta):
	verificaSessao()
		
		
func verificaSessao():
	if(SessaoUsuario.isLogada):
		perfilBotao.text = SessaoUsuario.usuarioLogado.nomeUsuario
		loginBotao.text = "DESLOGAR"
		criarQuizBotao.visible = true
		iconBotaoCriarQuiz.visible = true
	else:
		perfilBotao.text = "DESLOGADO!"
		loginBotao.text = "LOGIN"
		criarQuizBotao.visible = false
		iconBotaoCriarQuiz.visible = false
