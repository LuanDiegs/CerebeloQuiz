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
	var sql = "
	SELECT 
		coment.*,
		u.*,
		(coment.quantidadeCurtidas - coment.quantidadeDescurtidas) AS diferencaCurtidas 
	FROM 
		(SELECT 
			c.*,
			(SELECT count(*) FROM " + EntidadeConstantes.CurtidasDescurtidasComentariosTabela + " cd WHERE cd.comentarioId = c.comentarioId AND cd.acao = 1) AS quantidadeCurtidas,
			(SELECT count(*) FROM " + EntidadeConstantes.CurtidasDescurtidasComentariosTabela + " cd WHERE cd.comentarioId = c.comentarioId AND cd.acao = 2) AS quantidadeDescurtidas
		FROM " + EntidadeConstantes.ComentariosTabela + " c) AS coment
	INNER JOIN " + EntidadeConstantes.UsuarioTabela + " u ON coment.usuarioId = u.usuarioId
	WHERE coment.perguntaId=?
	ORDER BY isFixado DESC, diferencaCurtidas DESC"
	
	var parametros = [perguntaId]
	
	banco.query_with_bindings(sql, parametros)
	
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
