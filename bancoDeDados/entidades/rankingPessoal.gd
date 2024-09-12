extends EntidadeBase
class_name RankingPessoal

var propriedades: Dictionary

func instanciaEntidade(pontuacao: int, quizId: int, usuarioId: int):
	self.propriedades = {
		"pontuacao": pontuacao,
		"quizId": quizId,
		"usuarioId": usuarioId,
	}
	
	return propriedades
