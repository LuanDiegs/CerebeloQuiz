extends EntidadeBase
class_name Usuarios

var propriedades: Dictionary

#Propriedades da entidade
var idUsuario: int
var nomeUsuario: String
var emailUsuario: String
var isDesativado: bool
var dataDeNascimento: String
var idade: int
var isMaiorDeIdade: bool
var isModerador: bool

func instanciaEntidade(nome: String, email: String, senha: String, dataNascimento: String, telefone: String):
	self.propriedades = {
		"nome": nome,
		"email": email,
		"senha": senha,
		"dataNascimento": dataNascimento,
		"telefone": telefone,
		"isDesativado": false,
	}
	
	return propriedades
	
	
func verificarLogin(email: String, senha: String):
	var banco = BD.banco as SQLite
	var query = "SELECT * FROM " + EntidadeConstantes.UsuarioTabela + " WHERE email=? AND senha=?"
	var parametros = [email, senha]
	
	banco.query_with_bindings(query, parametros)
	
	var usuario
	if(banco.query_result): 
		usuario = banco.query_result[0]

	return usuario


func getUsuario(usuarioId) -> Usuarios:
	var banco = BD.banco as SQLite
	var query = "SELECT *, (strftime('%Y', 'now') - strftime('%Y', dataNascimento)) - (strftime('%m-%d', 'now') < strftime('%m-%d', dataNascimento)) as idade FROM " + EntidadeConstantes.UsuarioTabela + " WHERE usuarioId=?"

	var parametros = [usuarioId]

	banco.query_with_bindings(query, parametros)
	
	if(banco.query_result): 
		return _criaEntidade(banco.query_result[0])
	
	return null


func _criaEntidade(dados: Dictionary) -> Usuarios:
	var entidade = Usuarios.new()
	
	entidade.idUsuario = dados.get("usuarioId")
	entidade.nomeUsuario = dados.get("nome")
	entidade.emailUsuario = dados.get("email")
	entidade.isDesativado = dados.get("isDesativado")
	entidade.dataDeNascimento = dados.get("dataNascimento")
	entidade.idade = dados.get("idade")
	entidade.isMaiorDeIdade = true if entidade.idade >= 18 else false
	entidade.isModerador = dados.get("isModerador")
	
	return entidade


func existeUsuarioComEmail(email: String):
	var banco = BD.banco as SQLite
	var query = "SELECT * FROM " + EntidadeConstantes.UsuarioTabela + " WHERE email=?"
	var parametros = [email]

	banco.query_with_bindings(query, parametros)
	if(banco.query_result.size() > 0): 
		return true
	
	return false


func existeUsuarioComNome(usuario: String):
	var banco = BD.banco as SQLite
	var query = "SELECT * FROM " + EntidadeConstantes.UsuarioTabela + " WHERE nome=?"
	var parametros = [usuario]

	banco.query_with_bindings(query, parametros)
	if(banco.query_result.size() > 0): 
		return true
	
	return false


func desativarUsuario(usuarioId: int):
	var banco = BD.banco as SQLite
	var dictionaryUpdate = {"isDesativado": true}
	var condicao = "usuarioId = " + str(usuarioId)
	
	return banco.update_rows(EntidadeConstantes.UsuarioTabela, condicao, dictionaryUpdate)
