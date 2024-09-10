extends EntidadeBase
class_name Perguntas

var propriedades: Dictionary

func instanciaEntidade(conteudoPergunta: String, quizId: int):
	self.propriedades = {
		"conteudoPergunta": conteudoPergunta,
		"quizId": quizId,
	}
	
	return propriedades
