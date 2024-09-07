extends EntidadeBase
class_name Usuarios

var propriedades: Dictionary

#Propriedades da entidade
var idUsuario: int
var nomeUsuario: String
var emailUsuario: String
var isDesativado: bool

func instanciaEntidade(nome: String, email: String, senha: String, dataNascimento: String, telefone: String):
	self.propriedades = {
		"nome": nome,
		"email": email,
		"senha": senha,
		"datanascimento": dataNascimento,
		"telefone": telefone,
		"isdesativado": false,
	}
	
	return propriedades
	
	
func verificarLogin(email: String, senha: String):
	var banco = BD.banco as SQLite
	var query = "SELECT usuarioId FROM " + EntidadeConstantes.UsuarioTabela + " WHERE email=? AND senha=?"
	var parametros = [email, senha]
	
	banco.query_with_bindings(query, parametros)
	
	var usuarioId
	if(banco.query_result): 
		usuarioId = banco.query_result[0].usuarioId

	return usuarioId


func getUsuario(usuarioId):
	var banco = BD.banco as SQLite
	var query = "SELECT * FROM " + EntidadeConstantes.UsuarioTabela + " WHERE usuarioId=?"
	var parametros = [usuarioId]

	banco.query_with_bindings(query, parametros)
	
	if(banco.query_result): 
		return _criaEntidade(banco.query_result[0])


func _criaEntidade(dados: Dictionary):
	var entidade = Usuarios.new()
	
	entidade.idUsuario = dados.get("usuarioId")
	entidade.nomeUsuario = dados.get("nome")
	entidade.emailUsuario = dados.get("email")
	entidade.isDesativado = dados.get("isDesativado")
	
	return entidade
