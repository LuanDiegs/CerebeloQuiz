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

		
func atualizarDados(tableName: String, condicoes: String, dados: Dictionary):
	return banco.update_rows(tableName, condicoes, dados)
	
	
func deletarDados(tableName: String, condicoes: String):
	return banco.delete_rows(tableName, condicoes)
