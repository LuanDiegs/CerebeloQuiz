extends EntidadeBase
class_name Perguntas

var propriedades: Dictionary

func instanciaEntidade(conteudoTexto: String, quizId: int):
	self.propriedades = {
		"conteudoTexto": conteudoTexto,
		"quizId": quizId,
	}
	
	return propriedades
