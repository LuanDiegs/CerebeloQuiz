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
