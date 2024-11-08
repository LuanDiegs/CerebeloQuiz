extends EntidadeBase
class_name CategoriasQuiz

func getCategoriasQuiz():
	var banco = BD.banco as SQLite
	var query = "SELECT * from " + EntidadeConstantes.CategoriasTabela
	banco.query(query)

	return banco.query_result
