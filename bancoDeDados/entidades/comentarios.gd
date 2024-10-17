extends EntidadeBase
class_name Comentario

var propriedades: Dictionary

func instanciaEntidade(descricao: String, quizId: int, usuarioId: int):
	self.propriedades = {
		"comentarioDescricao": descricao,
		"quizId": quizId,
		"usuarioId": usuarioId
	}
	
	return propriedades
