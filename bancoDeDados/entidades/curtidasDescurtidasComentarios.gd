extends EntidadeBase
class_name CurtidasDescurtidasComentario

var propriedades: Dictionary
enum acaoComentario { Curtida = 1, Descurtida = 2 }

func instanciaEntidade(comentarioId: int, acao: acaoComentario):
	self.propriedades = {
		"comentarioId": comentarioId,
		"usuarioId": SessaoUsuario.usuarioLogado.idUsuario,
		"acao": acao
	}
	
	return propriedades


func inserirCurtidaDescurtidaComentario(comentarioId: int, acao: acaoComentario):
	if _deletarCurtidaDescurtidaUsuarioSeExistir(comentarioId):
		var banco = BD.banco as SQLite
		var dadoAInserir = instanciaEntidade(comentarioId, acao)
		
		return  banco.insert_row(EntidadeConstantes.CurtidasDescurtidasComentariosTabela, dadoAInserir)
	return false


func getQuantidadeCurtidasDescurtidasComentario(comentarioId: int):
	var banco = BD.banco as SQLite
	var sql = "SELECT count(*) as quantidade, acao from " + EntidadeConstantes.CurtidasDescurtidasComentariosTabela + " WHERE comentarioId=? GROUP BY acao"
	var params = [comentarioId]
	
	banco.query_with_bindings(sql, params)
	
	var response = banco.query_result as Array
	var responseFormatado: Array[Dictionary] = [
		{ "quantidade": 0, "acao": 1 },
		{ "quantidade": 0, "acao": 2 }
	]

	for curtidaOuDescurtida in response:
		match curtidaOuDescurtida.acao:
			1:
				responseFormatado[0]["quantidade"] = curtidaOuDescurtida.quantidade
			2:
				responseFormatado[1]["quantidade"] = curtidaOuDescurtida.quantidade

	return responseFormatado


func getCurtidaDescurtidaDoUsuarioNoComentario(comentarioId: int):
	var banco = BD.banco as SQLite
	var usuarioId = SessaoUsuario.usuarioLogado.idUsuario
	var sql = "SELECT * from " + EntidadeConstantes.CurtidasDescurtidasComentariosTabela + " WHERE comentarioId=? AND usuarioId=?"
	var params = [comentarioId, usuarioId]
	
	banco.query_with_bindings(sql, params)
	
	return banco.query_result


func _deletarCurtidaDescurtidaUsuarioSeExistir(comentarioId: int):
	var banco = BD.banco as SQLite
	var usuarioId = SessaoUsuario.usuarioLogado.idUsuario
	var usuarioCurtidaDescurtida = getCurtidaDescurtidaDoUsuarioNoComentario(comentarioId)
	
	if usuarioCurtidaDescurtida.size() > 0:
		var condicaoDelecao = "comentarioId=" + str(comentarioId) + " AND usuarioId=" + str(usuarioId)
		
		return banco.delete_rows(EntidadeConstantes.CurtidasDescurtidasComentariosTabela, condicaoDelecao)
	return true
