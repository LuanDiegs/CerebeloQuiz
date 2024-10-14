extends EntidadeBase
class_name DenunciaMotivos

var propriedades: Dictionary

func instanciaEntidade(justificativa: String, quizId: int, usuarioId: int):
	self.propriedades = {
		"justificativa": justificativa,
		"quizId": quizId,
		"usuarioId": usuarioId
	}
	
	return propriedades


func inserirVariosMotivosDaDenuncia(idsDosMotivos: Array, denunciaId: int):
	var banco = BD.banco as SQLite
	var dadosAInserir: Array
	
	for id in idsDosMotivos:
		dadosAInserir.append({
			"denunciaId": denunciaId,
			"motivoId": id
		})
	
	return banco.insert_rows(EntidadeConstantes.DenunciaMotivosTabela, dadosAInserir)
