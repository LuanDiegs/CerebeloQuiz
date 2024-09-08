extends Panel
class_name Sidebar

@onready var loginBotao = $SessaoDeLogin/ContainerSessaoLogin/Login
@onready var perfilBotao = $SessaoDeUsuario/ContainerUsuario/Perfil
@onready var icon_botao_criar_quiz: TextureRect = $SessaoCentral/IconBotaoCriarQuiz
@onready var criarQuizBotao: BotaoCriarQuizz = $SessaoCentral/SessaoCentral/BotaoCriarQuiz/CriarQuiz

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
		icon_botao_criar_quiz.visible = true
	else:
		perfilBotao.text = "DESLOGADO!"
		loginBotao.text = "LOGIN"
		criarQuizBotao.visible = false
		icon_botao_criar_quiz.visible = false
