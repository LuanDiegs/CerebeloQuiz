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
	if (!banco.insert_row(EntidadeConstantes.QuizzesTabela, quiz)):
		return false
	
	var idQuizInserido = banco.last_insert_rowid
	
	for pergunta in perguntas:
		pergunta = pergunta as ContainerPerguntaQuiz
		var perguntaAInserir = Perguntas.new().instanciaEntidade(pergunta.conteudoPergunta, idQuizInserido)
		
		if (!banco.insert_row(EntidadeConstantes.PerguntasTabela, perguntaAInserir)):
			return false
			
		var alternativas = pergunta.alternativasConteudoSalvas
		var idPergunta = banco.last_insert_rowid
		var alternativasAInserir = Alternativas.new().instanciaEntidades(alternativas, idPergunta)
		
		if (!banco.insert_rows(EntidadeConstantes.AlternativasTabela, alternativasAInserir)):
			return false
			
	return true


func editarInserirQuiz(
	idRegistroEdicao: int,
	quiz,
	perguntasBanco,
	perguntasAlterarInserir):
	var banco = BD.banco as SQLite
	
	var condicaoQuiz = "quizId = " + str(idRegistroEdicao)
	banco.update_rows(EntidadeConstantes.QuizzesTabela, condicaoQuiz, quiz)
	
	#Perguntas
	alterarInserirPergunta(perguntasBanco, perguntasAlterarInserir, idRegistroEdicao)


func alterarInserirPergunta(
	perguntasBanco: Dictionary,
	perguntasInserirAlterarRemover: Array,
	idQuiz: int):
	var banco = BD.banco as SQLite
	var perguntasAlterar: Array
	var perguntasInserir: Dictionary
	var perguntasRemover: Array
	
	var alternativasAlterar: Dictionary
	var alternativasInserir: Array
	var alternativasRemover: Array
	
	var perguntasFormatadas = formatarPerguntas(perguntasInserirAlterarRemover, idQuiz)
	var perguntasEAlternativasRemover = getPerguntasApagadas(perguntasBanco, perguntasFormatadas)
	perguntasRemover.append_array(perguntasEAlternativasRemover[0])
	alternativasRemover.append_array(perguntasEAlternativasRemover[1])
	for pergunta in perguntasFormatadas:
		#Se existir e ela for mudada, altera a pergunta
		if perguntasBanco.has(pergunta):
			if perguntasBanco.get(pergunta).conteudoPergunta != perguntasFormatadas.get(pergunta).conteudoPergunta:
				perguntasAlterar.append({
					"perguntaId": pergunta,
					"conteudoPergunta": perguntasFormatadas.get(pergunta).conteudoPergunta
				})
				
			#Alternativas
			var alternativasPergunta = formatarAlternativas(perguntasFormatadas.get(pergunta).alternativas, pergunta)
			var alternativasSalvasBanco = formatarAlternativas(perguntasBanco.get(pergunta).alternativas, pergunta)
			alternativasRemover.append_array(getAlternativasApagadas(alternativasSalvasBanco, alternativasPergunta))
			
			for alternativa in alternativasPergunta:
				#Inseriu
				if !alternativasSalvasBanco.has(alternativa) and alternativa < 0:
					alternativasInserir.append(alternativasPergunta.get(alternativa))
				
				#Alterou
				if alternativasSalvasBanco.has(alternativa):
					if alternativasPergunta.get(alternativa).conteudoAlternativa != alternativasSalvasBanco.get(alternativa).conteudoAlternativa or alternativasPergunta.get(alternativa).isAlternativaCorreta != alternativasSalvasBanco.get(alternativa).isAlternativaCorreta:
						alternativasAlterar.get_or_add(alternativa, alternativasPergunta.get(alternativa))
		#Caso não, insere uma nova pergunta
		else:
			perguntasInserir.get_or_add(
				{
					"id": pergunta,
					"alternativas": perguntasFormatadas.get(pergunta).alternativas
				},
				{
					"conteudoPergunta": perguntasFormatadas.get(pergunta).conteudoPergunta,
					"quizId": idQuiz
				})
		
	#region Inserts, delets e updates
	#Alterar perguntas existentes
	for pergunta in perguntasAlterar:
		var condicaoPergunta = "perguntaId = " + str(pergunta.perguntaId)
		banco.update_rows(EntidadeConstantes.PerguntasTabela, condicaoPergunta, pergunta)
	
	#Insere novas pergunta
	for pergunta in perguntasInserir:
		banco.insert_row(EntidadeConstantes.PerguntasTabela, perguntasInserir.get(pergunta))
		
		var perguntaInseridaId = banco.last_insert_rowid
		var alternativas = pergunta.alternativas
		
		for alternativa in alternativas:
			alternativasInserir.append({
					"conteudoAlternativa": alternativa.conteudoAlternativa,
					"isAlternativaCorreta": alternativa.isAlternativaCorreta,
					"perguntaId": perguntaInseridaId
				})
	
	#Remover perguntas
	for perguntaRemover in perguntasRemover:
		banco.delete_rows(EntidadeConstantes.PerguntasTabela, "perguntaId = " + str(perguntaRemover))
		
	#Insere alternativas das perguntas já criadas
	if alternativasInserir:
		banco.insert_rows(EntidadeConstantes.AlternativasTabela, alternativasInserir)
	
	#Alterar perguntas existentes
	for alternativa in alternativasAlterar:
		var condicaoAlternativa = "alternativaId = " + str(alternativa)
		banco.update_rows(EntidadeConstantes.AlternativasTabela, condicaoAlternativa, alternativasAlterar.get(alternativa))
		
	#Remover alternativas
	for alternativaRemover in alternativasRemover:
		banco.delete_rows(EntidadeConstantes.AlternativasTabela, "alternativaId = " + str(alternativaRemover))
#endregion


func formatarAlternativas(alternativas: Array, perguntaId: int = 0) -> Dictionary:
	var alternativasFormatadas: Dictionary = {}
	var indexNovasAlternativas = -1
	
	for alternativa in alternativas:
		alternativasFormatadas.get_or_add(
			alternativa.alternativaId if alternativa.alternativaId > 0 else indexNovasAlternativas,
			{
				"conteudoAlternativa": alternativa.conteudoAlternativa,
				"isAlternativaCorreta": alternativa.isAlternativaCorreta,
				"perguntaId": perguntaId
			})
		indexNovasAlternativas -= 1
	
	return alternativasFormatadas


func formatarPerguntas(perguntas: Array, quizId: int) -> Dictionary:
	perguntas = perguntas as Array[ContainerPerguntaQuiz]
	var perguntasFormatadas: Dictionary = {}
	var indexNovasPerguntas = -1
	
	for pergunta in perguntas:
		perguntasFormatadas.get_or_add(
			pergunta.idPergunta if pergunta.idPergunta > 0 else indexNovasPerguntas,
			{
				"conteudoPergunta": pergunta.conteudoPergunta,
				"alternativas": pergunta.alternativasConteudoSalvas,
				"quizId": quizId
			})
		indexNovasPerguntas -= 1
	
	return perguntasFormatadas


func getAlternativasApagadas(alternativasBanco: Dictionary, alternativasPergunta: Dictionary) -> Array:
	var alternativaIdsApagar: Array = []
	
	for alternativa in alternativasBanco:
		if !alternativasPergunta.has(alternativa) and alternativa > 0:
			alternativaIdsApagar.append(alternativa)
		
	return alternativaIdsApagar


func getPerguntasApagadas(perguntasBanco: Dictionary, perguntas: Dictionary) -> Array:
	var perguntasIdsApagar: Array = []
	var alternativasDaPerguntaApagar: Array = []
	
	for pergunta in perguntasBanco:
		if !perguntas.has(pergunta) and pergunta > 0:
			perguntasIdsApagar.append(pergunta)
			for alternativa in perguntasBanco.get(pergunta).alternativas:
				alternativasDaPerguntaApagar.append(alternativa.alternativaId)
			
	return [perguntasIdsApagar, alternativasDaPerguntaApagar]
	

#region QuizFavoritado
func favoritarQuiz(quizId):
	if (!SessaoUsuario.usuarioLogado):
		return
	
	var banco = BD.banco as SQLite
	var entidade: Dictionary = {"quizId": quizId, "usuarioId": SessaoUsuario.usuarioLogado.idUsuario}
	
	if (banco.insert_row(EntidadeConstantes.QuizzesFavoritosTabela, entidade)):
		return banco.last_insert_rowid
	
	return false


func desfavoritarQuiz(favoritadoId):
	var banco = BD.banco as SQLite
	var condicao = "quizFavoritoId=" + str(favoritadoId)
	
	if (banco.delete_rows(EntidadeConstantes.QuizzesFavoritosTabela, condicao)):
		return true
	
	return false


func getQuizFavoritado(quizId):
	if (!SessaoUsuario.usuarioLogado):
		return null
		
	var banco = BD.banco as SQLite
	var query = "SELECT * from " + EntidadeConstantes.QuizzesFavoritosTabela + " WHERE quizId=? and usuarioId=?"
	var params = [quizId, SessaoUsuario.usuarioLogado.idUsuario]
	
	banco.query_with_bindings(query, params)
	
	return banco.query_result


func getTodosQuizzesFavoritadosPublicos():
	var banco = BD.banco as SQLite
	
	var query = "SELECT * FROM " + EntidadeConstantes.QuizzesFavoritosTabela + " f 
		INNER JOIN" + EntidadeConstantes.UsuarioTabela + " u ON f.usuarioId = u.usuarioId 
		INNER JOIN" + EntidadeConstantes.QuizzesTabela + " q ON f.quizId = q.quizId 
		WHERE q.isPrivado=0 AND u.usuarioId =" + str(SessaoUsuario.usuarioLogado.idUsuario)

	if (banco.query(query)):
		return banco.query_result
	
	return []
#endregion

func getQuizCompleto(idQuiz):
	var banco = BD.banco as SQLite
	var query = "SELECT * FROM " + EntidadeConstantes.QuizzesTabela + " q 
	INNER JOIN" + EntidadeConstantes.PerguntasTabela + " p ON p.quizId = q.quizId 
	INNER JOIN" + EntidadeConstantes.AlternativasTabela + " a ON a.perguntaId = p.perguntaId 
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
				"conteudoAlternativa": perguntasEAlternativas[j].conteudoAlternativa,
				"isAlternativaCorreta": true if perguntasEAlternativas[j].isAlternativaCorreta == 1 else false,
				"alternativaId": perguntasEAlternativas[j].alternativaId,
			})
		
		if (!perguntas.has(perguntasAgrupadas[i])):
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
	
	if (banco.query_with_bindings(query, param)):
		return banco.query_result
	
	return []


func getTodosQuizzesPublicos():
	var banco = BD.banco as SQLite
	var query = "SELECT * FROM " + EntidadeConstantes.QuizzesTabela + " q 
		INNER JOIN" + EntidadeConstantes.UsuarioTabela + " u ON q.usuarioId = u.usuarioId 
		WHERE isPrivado=0"
	
	if (banco.query(query)):
		return banco.query_result
	
	return []
