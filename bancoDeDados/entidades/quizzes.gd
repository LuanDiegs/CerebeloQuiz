extends EntidadeBase
class_name Quizzes

var dadoAInserir: Dictionary

func instanciaEntidade(titulo: String, isPrivado: bool, classificacaoIndicativa: int, usuarioId: int):
	self.dadoAInserir = {
		"titulo": titulo,
		"isPrivado": isPrivado,
		"classificacaoIndicativa": classificacaoIndicativa,
		"usuarioId": usuarioId,
	}
	
	return dadoAInserir
