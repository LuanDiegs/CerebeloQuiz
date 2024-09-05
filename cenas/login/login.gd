extends Control
class_name Login

@onready var email := $"Formulário/Email"
@onready var senha := $"Formulário/Senha"
@onready var logar := $"Formulário/Logar"

func _ready():
	senha.secret = true
	logar.connect("pressed", realizarLogin)


func realizarLogin():
	if(validaCampos()):
		var banco = BD.banco as SQLite
		var response = Usuarios.new().verificarLogin(email.text, senha.text)

		if(response):
			SessaoUsuario.sessaoAtivada()
			TransicaoCena.trocar_cena(TransicaoCena.telaQuizzesPopulares)
		else:
			var popUpNotificacao = preload("res://componentes/popUps/popUpNotificacao/popUpNotificacao.tscn").instantiate()
			PopUp.criaPopupNotificacao("O email ou senha inválidos")


func validaCampos():
	var valido = true
	var msgCampoObrigatorio = "O campo é obrigatório"
	
	#Valida email
	if(email.text.is_empty()):
		email.insereErroNoInput(msgCampoObrigatorio)
		valido = false
	elif(!email.text.contains("@")):
		email.insereErroNoInput("O email é inválido")
		valido = false
	else:
		email.removeErroNoInput()
		
	#Valida senha
	if(senha.text.is_empty()):
		senha.insereErroNoInput(msgCampoObrigatorio)
		valido = false
	else:
		senha.removeErroNoInput()
	
	return valido
