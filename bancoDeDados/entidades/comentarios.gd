extends EntidadeBase
class_name Comentario

var propriedades: Dictionary

func instanciaEntidade(comentarioDescricao: String, perguntaId: int, usuarioId: int):
	self.propriedades = {
		"comentarioDescricao": comentarioDescricao,
		"perguntaId": perguntaId,
		"usuarioId": usuarioId
	}
	
	return propriedades


func inserirComentario(comentarioDescricao: String, perguntaId: int):
	var banco = BD.banco as SQLite
	var dadoAInserir = instanciaEntidade(comentarioDescricao, perguntaId, SessaoUsuario.usuarioLogado.idUsuario)
	var responseComentario = banco.insert_row(EntidadeConstantes.ComentariosTabela, dadoAInserir)
	
	return responseComentario


func getComentariosDaPergunta(perguntaId: int):
	var banco = BD.banco as SQLite
	var sql = "SELECT * FROM " + EntidadeConstantes.ComentariosTabela + " c 
	INNER JOIN " + EntidadeConstantes.UsuarioTabela + " u ON c.usuarioId = u.usuarioId
	WHERE c.perguntaId=?
	ORDER BY c.quantidadeCurtidas"
	var parametros = [perguntaId]
	
	banco.query_with_bindings(sql, parametros)
	
	return banco.query_result
