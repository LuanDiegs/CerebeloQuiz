extends Control
class_name Login

@onready var email = $"Formulário/Email"
@onready var senha = $"Formulário/Senha"
@onready var logar = $"Formulário/Logar"

func _ready():
	senha.secret = true
	logar.connect("pressed", realizarLogin)


func realizarLogin():
	var banco = BD.banco as SQLite
	var response = Usuarios.new().verificarLogin(email.text, senha.text)

	if(response):
		SessaoUsuario.sessaoAtivada()
