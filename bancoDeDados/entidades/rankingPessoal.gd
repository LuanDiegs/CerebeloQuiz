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


func getRankingDoQuiz(quizId: int):
	var banco = BD.banco as SQLite
	var query = "SELECT * from " + EntidadeConstantes.RankingPessoalTabela + " r
		INNER JOIN " + EntidadeConstantes.UsuarioTabela + " u ON r.usuarioId = u.usuarioId
		WHERE quizId=? ORDER BY pontuacao DESC LIMIT 15"
	var params = [quizId]
	banco.query_with_bindings(query, params)
	
	var dadosDoRanking: Array
	if(banco.query_result):
		for entidade in banco.query_result:
			dadosDoRanking.append({
				"pontuacao": entidade.pontuacao,
				"usuario": entidade.nome
			})
				
	return dadosDoRanking
