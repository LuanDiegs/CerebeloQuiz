extends EntidadeBase
class_name Denuncia

var propriedades: Dictionary

func instanciaEntidade(justificativa: String, quizId: int, usuarioId: int):
	self.propriedades = {
		"justificativa": justificativa,
		"quizId": quizId,
		"usuarioId": usuarioId
	}
	
	return propriedades


func salvarDenuncia(denuncia: Dictionary, idsDosMotivos: Array):
	var banco = BD.banco as SQLite
	var responseDenuncia = banco.insert_row(EntidadeConstantes.DenunciasTabela, denuncia)
	
	if responseDenuncia:
		var idDenunciaInserida = banco.last_insert_rowid	
		var responseMotivos = DenunciaMotivos.new().inserirVariosMotivosDaDenuncia(idsDosMotivos, idDenunciaInserida)
		
		return responseMotivos
	
	return false


func getDenunciasFormatadas() -> Dictionary:
	var banco = BD.banco as SQLite
	var sql = "SELECT count(*) as quantidade, q.titulo, q.quizId, d.denunciaId, md.descricao, q.usuarioId FROM " + EntidadeConstantes.DenunciaMotivosTabela + " dm 
		INNER JOIN " + EntidadeConstantes.DenunciasTabela + " d ON dm.denunciaId = d.denunciaId 
		INNER JOIN " + EntidadeConstantes.MotivosDenunciaTabela + " md ON dm.motivoId = md.motivosDenunciaId
		INNER JOIN " + EntidadeConstantes.QuizzesTabela + " q ON q.quizId = d.quizId
		WHERE q.isDesativado = 0
		GROUP BY md.motivosDenunciaId, d.quizId
		ORDER BY quantidade DESC"
		
	if(banco.query(sql)):
		var response: Array = banco.query_result
		var denunciasAgrupadas: Dictionary
		
		for denuncia in response:
			if(!denunciasAgrupadas.has(denuncia.quizId)):
				denunciasAgrupadas.get_or_add(denuncia.quizId, 
					{ 
						"quizTitulo": denuncia.titulo, 
						"motivos": [{denuncia.descricao: denuncia.quantidade}],
						"quantidadeDenuncias": getNumeroDasDenunciasDeUmQuiz(denuncia.quizId),
						"usuarioId": denuncia.usuarioId
					})
			else:
				var motivos: Array = denunciasAgrupadas.get(denuncia.quizId).motivos
				
				for motivo in motivos:
					motivo = motivo as Dictionary
					
					if !motivos.has({denuncia.descricao: denuncia.quantidade}):		
						motivos.append({denuncia.descricao: denuncia.quantidade})
						denunciasAgrupadas[denuncia.quizId].motivos = motivos
				
		return denunciasAgrupadas
	return {}


func getNumeroDasDenunciasDeUmQuiz(quizId: int):
	var banco = BD.banco as SQLite
	var sql = "SELECT count(*) as quantidade FROM " + EntidadeConstantes.DenunciasTabela + " WHERE quizId=?"
	var params = [quizId]
	
	if(banco.query_with_bindings(sql, params)):
		return banco.query_result[0].quantidade


func getDenunciasJustificativasDoQuiz(quizId: int) -> Array:
	var banco = BD.banco as SQLite
	var sql = "SELECT d.justificativa, u.nome FROM " + EntidadeConstantes.DenunciasTabela + " d
		INNER JOIN " + EntidadeConstantes.UsuarioTabela + " u ON u.usuarioId = d.usuarioId 
		WHERE d.quizId = ?"
	var params = [quizId]
	
	if banco.query_with_bindings(sql, params):
		var resultado = banco.query_result
		
		return resultado
	
	return []
	
