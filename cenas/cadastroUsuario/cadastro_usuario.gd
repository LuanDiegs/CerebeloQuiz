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


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func cadastrarUsuario() -> void:
	var usuario = Usuarios.new(usuario.text, email.text, senha.text, data_nascimento.text, telefone.text)
	BD.inserirDados(EntidadeConstantes.UsuarioTabela, usuario.dadoAInserir)
