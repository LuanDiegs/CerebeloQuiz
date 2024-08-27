extends Control
class_name CadastroUsuario

@onready var usuario = $Formulario/Usuario
@onready var email = $Formulario/Email
@onready var data_nascimento = $Formulario/DataNascimento
@onready var telefone = $Formulario/Telefone
@onready var senha = $Formulario/Senha
@onready var confirma_senha = $Formulario/ConfirmaSenha
@onready var cadastrar_botao = $Formulario/CadastrarBotao

func _ready():
	cadastrar_botao.connect("pressed", cadastrarUsuario)


func cadastrarUsuario() -> void:
	var usuario = Usuarios.new().instanciaEntidade(usuario.text, email.text, senha.text, data_nascimento.text, telefone.text)
	var response = BD.inserirDados(EntidadeConstantes.UsuarioTabela, usuario)
	
#	Se retornar true significa que a inserção foi um sucesso
	if(response):
		limparCampos()
		print("Sucesso")
	else:
		print("Erro")
		
		
func limparCampos():
	usuario.clear()
	email.clear()
	senha.clear()
	data_nascimento.clear()
	telefone.clear()
