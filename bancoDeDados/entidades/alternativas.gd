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

func instanciaEntidades(alternativas: Array , perguntaId: int):
	var dados = alternativas.map(converteEntidade.bind(perguntaId))
	
	return dados
	

func converteEntidade(valor, perguntaId):
	var propriedade = {
		"conteudoTexto": valor[0],
		"isAlternativaCorreta": valor[1],
		"perguntaId": perguntaId,
	}
	
	return propriedade
	
