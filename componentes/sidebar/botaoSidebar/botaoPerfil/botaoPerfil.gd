extends BotaoMenuSidebar
class_name BotaoPerfil

@onready var _moderadorlabel = $"../ModeradorLabel"
@onready var _separador4 = $"../Separador4"

@onready var _temaNormal = preload("res://componentes/sidebar/botaoSidebar/botaoNormalSidebarTema.tres")
@onready var _temaModerador = preload("res://componentes/sidebar/botaoSidebar/botaoPerfil/botaoModeradorSidebarTema.tres")

func _ready():
	connect("pressed", _on_pressed)
	

func _process(_delta):
	var temaBotao = _temaNormal
	var isModerador = true if SessaoUsuario.isLogada and SessaoUsuario.usuarioLogado and SessaoUsuario.usuarioLogado.isModerador else false
	
	if isModerador:
		temaBotao = _temaModerador
		
	if self.theme != temaBotao:
		_separador4.visible = !isModerador
		_moderadorlabel.visible = isModerador
		trocarTema(temaBotao)


func trocarTema(tema):
	self.theme = tema
