extends BotaoMenuSidebar
class_name BotaoPerfil

@onready var _moderadorlabel = $"../ModeradorLabel"
@onready var _separador4 = $"../Separador4"

func _ready():
	connect("pressed", _on_pressed)
	

func _process(delta):
	var temaBotao = preload("res://componentes/sidebar/botaoSidebar/botaoNormalSidebarTema.tres")
	var isModerador = false
	
	if SessaoUsuario.isLogada and SessaoUsuario.usuarioLogado and SessaoUsuario.usuarioLogado.isModerador:
		temaBotao = preload("res://componentes/sidebar/botaoSidebar/botaoPerfil/botaoModeradorSidebarTema.tres")
		isModerador = true
		
	_separador4.visible = !isModerador
	_moderadorlabel.visible = isModerador
	self.theme = temaBotao
