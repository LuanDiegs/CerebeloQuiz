extends Control
class_name CadastroUsuario

@onready var usuario := $Formulario/Usuario
@onready var email := $Formulario/Email
@onready var data_nascimento := $Formulario/DataNascimento
@onready var telefone := $Formulario/Telefone
@onready var senha := $Formulario/Senha
@onready var confirma_senha := $Formulario/ConfirmaSenha
@onready var cadastrar_botao = $Formulario/CadastrarBotao


var formularioValido := true
var msgCampoObrigatorio = "O campo é obrigatório"


func _ready():
	cadastrar_botao.connect("pressed", cadastrarUsuario)
	confirma_senha.connect("focus_exited", validaSenhas)
	senha.connect("focus_exited", validaSenhas)


func cadastrarUsuario() -> void:
	formularioValido = true
	validaCampos()
	
	if(formularioValido):
		var usuario = Usuarios.new().instanciaEntidade(usuario.text, email.text, senha.text, data_nascimento.text, telefone.text)
		var response = BD.inserirDados(EntidadeConstantes.UsuarioTabela, usuario)

	 	#Se retornar true significa que a inserção foi um sucesso
		var popUpNotificacaoComponente = preload("res://componentes/popUps/popUpNotificacao/popUpNotificacao.tscn").instantiate()
		if(response):
			PopUp.criaPopupNotificacao(
				popUpNotificacaoComponente, 
				"Seu cadastro foi feito com sucesso!", 
				TransicaoCena.telaQuizzesPopulares)
			SessaoUsuario.sessaoAtivada()
		else:
			PopUp.criaPopupNotificacao(popUpNotificacaoComponente, "Ocorreu um erro ao realizar o cadastro")


func limparCampos():
	usuario.clear()
	email.clear()
	senha.clear()
	data_nascimento.clear()
	telefone.clear()
	confirma_senha.clear()


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
	if(data_nascimento.text.is_empty()):
		data_nascimento.insereErroNoInput(msgCampoObrigatorio)
		formularioValido = false
	else:
		data_nascimento.removeErroNoInput()
	
	validaSenhas()


func validaSenhas():
	var senhasValidas = true
	
	#Valida senha
	if(senha.text.is_empty()):
		senha.insereErroNoInput(msgCampoObrigatorio)
		formularioValido = false
		senhasValidas = false
	
	if(confirma_senha.text.is_empty()):
		confirma_senha.insereErroNoInput(msgCampoObrigatorio)
		formularioValido = false
		senhasValidas = false
	
	if(senha.text != confirma_senha.text):
		var msgSenhasNaoCoincidem = "As senhas não coincidem"
		senha.insereErroNoInput(msgSenhasNaoCoincidem)
		confirma_senha.insereErroNoInput(msgSenhasNaoCoincidem)
		formularioValido = false
		senhasValidas = false
	
	if(senhasValidas):
		senha.removeErroNoInput()
		confirma_senha.removeErroNoInput()
