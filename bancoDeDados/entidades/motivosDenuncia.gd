extends EntidadeBase
class_name MotivoDenuncia

var propriedades: Dictionary

func instanciaEntidade(descricao: String):
	self.propriedades = {
		"descricao": descricao,
	}
	
	return propriedades


func getMotivosDenuncia():
	var motivosArray: Array = []
	var banco = BD.banco as SQLite
	var query = "SELECT * FROM " + EntidadeConstantes.MotivosDenunciaTabela
	
	var response = banco.query(query)
	
	if response:
		var motivos = banco.query_result
		
		for motivo in motivos:
			motivosArray.append({
				"id": motivo.motivosDenunciaId,
				"descricao": motivo.descricao
			})
	
	return motivosArray
