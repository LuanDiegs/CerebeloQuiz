extends Node
class_name EntidadeBase

var db: BancoDeDados = BD

func inserirDados(nomeTabela: String, dados: Dictionary):
	return db.inserirDados(nomeTabela, dados)


func deletarDado(nomeTabela: String, condicoes: String):
	return db.deletarDados(nomeTabela, condicoes)


func atualizarDado(nomeTabela: String, condicoes: String, dados: Dictionary):
	return db.atualizarDados(nomeTabela, condicoes, dados)
