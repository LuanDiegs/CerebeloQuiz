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


func formataData(texto:String):
	if (texto.length() == 2 and texto.count("/") == 0) or (texto.length() == 5 and texto.count("/") == 1):
		texto = texto + "/"
		dataNascimento.text = texto
		dataNascimento.caret_column = texto.length()
		
	validaDataNascimento(texto)	


func formataTelefone(texto: String):
	validaTelefone(texto)


func validaTelefone(texto: String = ""):
	texto = texto if texto else telefone.text
	if texto.length() > 11:
		texto = texto.left(texto.length() - (texto.length() - 11))
		telefone.text = texto
		telefone.caret_column = texto.length()
	
	if texto and !texto.is_valid_int():
		telefone.insereErroNoInput("Insira um telefone válido")
		formularioValido = false
	else: 
		telefone.removeErroNoInput()
		formularioValido = true
		

func validaDataNascimento(texto: String = ""):
	texto = texto if texto else dataNascimento.text

	if texto.length() > 10:
		texto = texto.left(texto.length() - (texto.length() - 10))
		dataNascimento.text = texto
		dataNascimento.caret_column = texto.length()
		
	var regex = RegEx.new()
	regex.compile("(^(((0[1-9]|1[0-9]|2[0-8])[\\/](0[1-9]|1[012]))|((29|30|31)[\\/](0[13578]|1[02]))|((29|30)[\\/](0[4,6,9]|11)))[\\/](19|[2-9][0-9])\\d\\d$)|(^29[\\/]02[\\/](19|[2-9][0-9])(00|04|08|12|16|20|24|28|32|36|40|44|48|52|56|60|64|68|72|76|80|84|88|92|96)$)")
	
	var valido = regex.search(texto)
	if !valido:
		dataNascimento.insereErroNoInput("Insira uma data válida de nascimento válida!")
		formularioValido = false
	else: 
		dataNascimento.removeErroNoInput()
		formularioValido = true


func cadastrarUsuario() -> void:
	formularioValido = true
	validaCampos()
	
	if(formularioValido):
		if(Usuarios.new().existeUsuarioComEmail(email.text)):
			PopUp.criaPopupNotificacao("Já existe um usuário com esse email!")
			return
			
		if(Usuarios.new().existeUsuarioComNome(usuario.text)):
			PopUp.criaPopupNotificacao("Já existe um usuário com esse nome de usuário!")
			return
			
		var arrayData = dataNascimento.text.split("/")
		var dataFormatada = str(arrayData[2] + "-" + arrayData[1] + "-" + arrayData[0])
		var usuario = Usuarios.new().instanciaEntidade(usuario.text, email.text, senha.text, dataFormatada, telefone.text)
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
	validaTelefone()
	validaDataNascimento()
	
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
