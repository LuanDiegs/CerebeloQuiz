extends Node
class_name BancoDeDados

var banco: SQLite = SQLite.new()


func _init():
	conectarBanco()

	
func conectarBanco():
	banco.path = "res://cerebelo.db"
	banco.verbosity_level = SQLite.NORMAL
	banco.open_db()
	verificaSePrecisaCriarTabelas()
	pass


func verificaSePrecisaCriarTabelas():
	#Verifica se existe a tabela de usuários, caso sim não roda o sql, caso não ele cria as tabelas
	banco.query("SELECT name FROM sqlite_master WHERE type='table' AND name='usuarios'")
	if(banco.query_result.size() == 0):
		var sqlArquivo = "res://bancoDeDados/sql.sql"
		var arquivo = FileAccess.open(sqlArquivo, FileAccess.READ)
		var sql = arquivo.get_as_text()
		banco.query(sql)


func inserirDados(tableName: String, data: Dictionary):
	if(banco.insert_row(tableName, data)):
		return banco.last_insert_rowid

		
func atualizarDados(tableName: String, condicoes: String, dados: Dictionary):
	return banco.update_rows(tableName, condicoes, dados)
	
	
func deletarDados(tableName: String, condicoes: String):
	return banco.delete_rows(tableName, condicoes)
