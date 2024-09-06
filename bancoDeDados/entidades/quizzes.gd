extends EntidadeBase
class_name Quizzes

var propriedades: Dictionary

func instanciaEntidade(titulo: String, isPrivado: bool, classificacaoIndicativa: int, usuarioId: int):
	self.propriedades = {
		"titulo": titulo,
		"isPrivado": isPrivado,
		"classificacaoIndicativa": classificacaoIndicativa,
		"usuarioId": usuarioId,
	}
	
	return propriedades
