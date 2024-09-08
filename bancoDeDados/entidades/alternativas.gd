extends EntidadeBase
class_name Alternativas

var propriedades: Dictionary

func instanciaEntidade(conteudo: String, isAlternativaCorreta: bool , perguntaId: int):
	self.propriedades = {
		"conteudoTexto": conteudo,
		"isAlternativaCorreta": isAlternativaCorreta,
		"perguntaId": perguntaId,
	}
	
	return propriedades
