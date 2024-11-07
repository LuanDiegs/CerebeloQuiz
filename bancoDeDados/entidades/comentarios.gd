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
	var sql = "SELECT *, (c.quantidadeCurtidas - c.quantidadeDescurtidas) AS diferencaCurtidas FROM " + EntidadeConstantes.ComentariosTabela + " c 
		INNER JOIN " + EntidadeConstantes.UsuarioTabela + " u ON c.usuarioId = u.usuarioId
		WHERE c.perguntaId=?
		ORDER BY isFixado DESC, diferencaCurtidas DESC"
	var parametros = [perguntaId]
	
	banco.query_with_bindings(sql, parametros)
	
	return banco.query_result


func incrementaQuantidadeCurtidaComentario(comentarioId: int, quantidadeCurtidas: int):
	var banco = BD.banco as SQLite
	var condicoes = "comentarioId="+str(comentarioId)
	var valorAlterar = {"quantidadeCurtidas": quantidadeCurtidas}
		
	banco.update_rows(EntidadeConstantes.ComentariosTabela, condicoes, valorAlterar)
	
	return banco.query_result


func incrementaQuantidadeDescurtidaComentario(comentarioId: int, quantidadeDescurtidas: int):
	var banco = BD.banco as SQLite
	var condicoes = "comentarioId="+str(comentarioId)
	var valorAlterar = {"quantidadeDescurtidas": quantidadeDescurtidas}
		
	banco.update_rows(EntidadeConstantes.ComentariosTabela, condicoes, valorAlterar)
	
	return banco.query_result
	

func fixaComentario(comentarioId: int, perguntaId: int):
	if desfixarComentarioDaPergunta(perguntaId):
		var banco = BD.banco as SQLite
		var condicao = "comentarioId=" + str(comentarioId)
		var objetoAlterar = {
			"isFixado": true
		}	
		
		return banco.update_rows(EntidadeConstantes.ComentariosTabela, condicao, objetoAlterar)


func desfixarComentarioDaPergunta(perguntaId: int):
	var banco = BD.banco as SQLite
	var sql = "SELECT comentarioId FROM " + EntidadeConstantes.ComentariosTabela + " WHERE 
		perguntaId=? and isFixado=?"
	var params = [perguntaId, true]
	
	banco.query_with_bindings(sql, params)

	if banco.query_result.size() > 0:
		var condicao = "comentarioId=" + str(banco.query_result[0].comentarioId)
		var objetoAlterar = {
			"isFixado": false
		}
		
		return banco.update_rows(EntidadeConstantes.ComentariosTabela, condicao, objetoAlterar)
	return true
