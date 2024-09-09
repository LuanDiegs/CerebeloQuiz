extends Node
class_name BancoDeDados

var banco: SQLite = SQLite.new()


func _init():
	conectarBanco()

	
func conectarBanco():
	banco.path = "res://cerebelo.db"
	banco.open_db()


func comecaTransacao():
	banco.query("BEGIN TRANSACTION;")
		
		
func finalizaTransacao():
	banco.query("END TRANSACTION;")


func inserirDados(tableName: String, data: Dictionary):
	if(banco.insert_row(tableName, data)):
		return banco.last_insert_rowid


func inserirQuiz(quiz, perguntas):
	var sucesso = true
	
	if(banco.insert_row(EntidadeConstantes.QuizzesTabela, quiz)):
		var idQuizInserido = banco.last_insert_rowid
		
		for pergunta in perguntas:
			pergunta = pergunta as ContainerPerguntaQuiz
			var perguntaAInserir = Perguntas.new().instanciaEntidade(pergunta.conteudoPergunta, idQuizInserido)
			
			if(banco.insert_row(EntidadeConstantes.PerguntasTabela, perguntaAInserir)):
				var alternativas = pergunta.alternativasConteudoSalvas
				var idPergunta = banco.last_insert_rowid
				var alternativasAInserir = Alternativas.new().instanciaEntidades(alternativas, idPergunta)
				
				if(!banco.insert_rows(EntidadeConstantes.AlternativasTabela, alternativasAInserir)):
					sucesso = false
			else:
				sucesso = false
	else:
		sucesso = false
	
	return sucesso	

		
func atualizarDados(tableName: String, condicoes: String, dados: Dictionary):
	return banco.update_rows(tableName, condicoes, dados)
	
	
func deletarDados(tableName: String, condicoes: String):
	return banco.delete_rows(tableName, condicoes)


func tabelaExiste(tableName: String):
	banco.query("SELECT name FROM sqlite_master WHERE type='table' AND name='" + tableName + "'")
	
	if(banco.query_result.size() > 0):
		return true
		
	return false
