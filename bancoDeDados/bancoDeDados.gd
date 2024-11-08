extends Node
class_name BancoDeDados

var banco: SQLite = SQLite.new()


func _init():
	conectarBanco()

	
func conectarBanco():
	if !DirAccess.dir_exists_absolute(OS.get_user_data_dir() + "/data"):
		DirAccess.make_dir_absolute(OS.get_user_data_dir() +"/data")
	banco.path = OS.get_user_data_dir() + "/data/cerebelo.db"
	banco.verbosity_level = SQLite.NORMAL
	banco.open_db()
	verificaSePrecisaCriarTabelas()
	pass


func verificaSePrecisaCriarTabelas():
	#Verifica se existe a tabela de usuários, caso sim não roda o sql, caso não ele cria as tabelas
	banco.query("SELECT name FROM sqlite_master WHERE type='table' AND name='usuarios'")
	
	if (banco.query_result.size() == 0):
		var file = FileAccess.open("res://bancoDeDados/sql.txt", FileAccess.READ)
		var sql = file.get_as_text()
		
		#Por algum motivo da erro de codificação ao inserir os motivos da denuncia, os caracteres
		#especiais ficam tudo torto, ent vou fazer manualmente essa porra
		var insercaoMotivosDenuncia = "INSERT INTO motivosDenuncia(descricao) VALUES ('Fake news'), ('Violação de copyright'), ('Conteúdo racista'), ('Conteúdo adulto'), ('Conteúdo homofóbico'), ('Plágio');"
		var insercaoCategorias = "INSERT INTO categoriasQuiz(descricao) VALUES ('Geral'), ('Literatura'), ('Geografia'), ('História'), ('Matemática'), ('Idiomas'), ('Cultura geek'), ('Biologia'), ('Cultura pop');"
	
		await banco.query(sql)
		await banco.query(insercaoMotivosDenuncia)
		await banco.query(insercaoCategorias)


func inserirDados(tableName: String, data: Dictionary):
	if (banco.insert_row(tableName, data)):
		return banco.last_insert_rowid

		
func atualizarDados(tableName: String, condicoes: String, dados: Dictionary):
	return banco.update_rows(tableName, condicoes, dados)
	
	
func deletarDados(tableName: String, condicoes: String):
	return banco.delete_rows(tableName, condicoes)
