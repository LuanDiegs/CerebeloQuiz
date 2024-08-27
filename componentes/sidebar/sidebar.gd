extends Panel
class_name Sidebar

@onready var loginBotao = $SessaoDeLogin/ContainerSessaoLogin/Login
@onready var perfilBotao = $SessaoDeUsuario/ContainerUsuario/Perfil

func _process(delta):
	sessaoIniciada()
		
		
func sessaoIniciada():
	if(SessaoUsuario.isLogada):
		perfilBotao.text = "LOGADO!"
		loginBotao.text = "DESLOGAR"
	else:
		perfilBotao.text = "DESLOGADO!"
		loginBotao.text = "LOGIN"
