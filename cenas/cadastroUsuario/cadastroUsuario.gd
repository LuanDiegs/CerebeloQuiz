extends Control
class_name CadastroUsuario

@onready var usuario := $Formulario/Usuario
@onready var email := $Formulario/Email
@onready var dataNascimento := $Formulario/DataNascimento
@onready var telefone := $Formulario/Telefone
@onready var senha := $Formulario/Senha
@onready var confirmaSenha := $Formulario/ConfirmaSenha
@onready var cadastrarBotao := $Formulario/CadastrarBotao


var formularioValido := true
var msgCampoObrigatorio := "O campo é obrigatório"


func _ready():
	cadastrarBotao.connect("pressed", cadastrarUsuario)
	confirmaSenha.connect("focus_exited", validaSenhas)
	senha.connect("focus_exited", validaSenhas)


func cadastrarUsuario() -> void:
	formularioValido = true
	validaCampos()
	
	if(formularioValido):
		var usuario = Usuarios.new().instanciaEntidade(usuario.text, email.text, senha.text, dataNascimento.text, telefone.text)
		var response = BD.inserirDados(EntidadeConstantes.UsuarioTabela, usuario)

	 	#Se retornar true significa que a inserção foi um sucesso
		var popUpNotificacaoComponente = preload("res://componentes/popUps/popUpNotificacao/popUpNotificacao.tscn").instantiate()
		if(response):
			PopUp.criaPopupNotificacao( 
				"Seu cadastro foi feito com sucesso!", 
				TransicaoCena.telaQuizzesPopulares)
			SessaoUsuario.sessaoAtivada(response)
		else:
			PopUp.criaPopupNotificacao("Ocorreu um erro ao realizar o cadastro")


func limparCampos():
	usuario.clear()
	email.clear()
	senha.clear()
	dataNascimento.clear()
	telefone.clear()
	confirmaSenha.clear()


func validaCampos():
	#Valida usuario
	if(usuario.text.is_empty()):
		usuario.insereErroNoInput(msgCampoObrigatorio)
		formularioValido = false
	else:
		usuario.removeErroNoInput()
	
	#Valida email
	if(email.text.is_empty()):
		email.insereErroNoInput(msgCampoObrigatorio)
		formularioValido = false
	elif(!email.text.contains("@")):
		email.insereErroNoInput("O email é inválido")
		formularioValido = false
	else:
		email.removeErroNoInput()
		
	#Valida data de nascimento
	if(dataNascimento.text.is_empty()):
		dataNascimento.insereErroNoInput(msgCampoObrigatorio)
		formularioValido = false
	else:
		dataNascimento.removeErroNoInput()
	
	validaSenhas()


func validaSenhas():
	var senhasValidas = true
	
	#Valida senha
	if(senha.text.is_empty()):
		senha.insereErroNoInput(msgCampoObrigatorio)
		formularioValido = false
		senhasValidas = false
	
	if(confirmaSenha.text.is_empty()):
		confirmaSenha.insereErroNoInput(msgCampoObrigatorio)
		formularioValido = false
		senhasValidas = false
	
	if(senha.text != confirmaSenha.text):
		var msgSenhasNaoCoincidem = "As senhas não coincidem"
		senha.insereErroNoInput(msgSenhasNaoCoincidem)
		confirmaSenha.insereErroNoInput(msgSenhasNaoCoincidem)
		formularioValido = false
		senhasValidas = false
	
	if(senhasValidas):
		senha.removeErroNoInput()
		confirmaSenha.removeErroNoInput()
