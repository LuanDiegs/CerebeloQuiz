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


func inserirQuiz(quiz, perguntas):
	var banco = BD.banco as SQLite
	if(!banco.insert_row(EntidadeConstantes.QuizzesTabela, quiz)):
		return false
	
	var idQuizInserido = banco.last_insert_rowid
	
	for pergunta in perguntas:
		pergunta = pergunta as ContainerPerguntaQuiz
		var perguntaAInserir = Perguntas.new().instanciaEntidade(pergunta.conteudoPergunta, idQuizInserido)
		
		if(!banco.insert_row(EntidadeConstantes.PerguntasTabela, perguntaAInserir)):
			return false
			
		var alternativas = pergunta.alternativasConteudoSalvas
		var idPergunta = banco.last_insert_rowid
		var alternativasAInserir = Alternativas.new().instanciaEntidades(alternativas, idPergunta)
		
		if(!banco.insert_rows(EntidadeConstantes.AlternativasTabela, alternativasAInserir)):
			return false
			
	return true


func editarQuiz(idRegistroEdicao: int, quiz, perguntas):
	var banco = BD.banco as SQLite
	var condicao = "WHERE "
	
	return 0


func getQuizCompleto(idQuiz):
	var banco = BD.banco as SQLite
	var query = "SELECT * FROM " + EntidadeConstantes.QuizzesTabela + " q 
	INNER JOIN " + EntidadeConstantes.PerguntasTabela + " p ON p.quizId = q.quizId 
	INNER JOIN " + EntidadeConstantes.AlternativasTabela + " a ON a.perguntaId = p.perguntaId 
	WHERE q.quizId = ?"
		
	var params = [idQuiz]
	
	banco.query_with_bindings(query, params)
	var resultado = banco.query_result as Array

	var perguntasIds: Array = resultado.map(func(valor): return valor.perguntaId)
	var perguntasAgrupadas = Utils.agruparArray(perguntasIds)
		
	var perguntas: Array
	for i in perguntasAgrupadas.size():
		var perguntasEAlternativas = resultado.filter(func(valor): if valor.perguntaId == perguntasAgrupadas[i]: return valor)
		
		var alternativas: Array
		for j in perguntasEAlternativas.size():
			alternativas.append(
			{
				"alternativaId": perguntasEAlternativas[j].alternativaId,
				"conteudoAlternativa": perguntasEAlternativas[j].conteudoAlternativa,
				"isAlternativaCorreta": perguntasEAlternativas[j].isAlternativaCorreta
			})
		
		if(!perguntas.has(perguntasAgrupadas[i])):
			perguntas.append(
			{
				"perguntaId": perguntasAgrupadas[i], 
				"conteudoPergunta": perguntasEAlternativas[0].conteudoPergunta,
				"alternativas": alternativas
			})
	
	var quiz = {
		"titulo": resultado[0].titulo,
		"isPrivado": resultado[0].isPrivado,
		"classificacaoIndicativa": resultado[0].classificacaoIndicativa,
		"usuarioId": resultado[0].usuarioId,
		"perguntas": perguntas
	}
	
	return quiz


func getPerguntasEAlternativasDoQuiz(idQuiz):
	var quizCompleto = getQuizCompleto(idQuiz)
	var perguntas = quizCompleto["perguntas"]
	
	return perguntas
	
	
func getQuizzesDoUsuario(idUsuario):
	var banco = BD.banco as SQLite
	var query = "SELECT * FROM " + EntidadeConstantes.QuizzesTabela + " WHERE usuarioId=?"
	var param = [idUsuario]
	
	if(banco.query_with_bindings(query, param)):
		return banco.query_result
	
	return []


func getTodosQuizzesPublicos():
	var banco = BD.banco as SQLite
	var query = "SELECT * FROM " + EntidadeConstantes.QuizzesTabela + " q 
		INNER JOIN " + EntidadeConstantes.UsuarioTabela + " u ON q.usuarioId = u.usuarioId 
		WHERE isPrivado=0"
	
	if(banco.query(query)):
		return banco.query_result
	
	return []
