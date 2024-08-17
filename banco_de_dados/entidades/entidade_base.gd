extends Node
class_name EntidadeBase

var db: BancoDeDados = BD

func inserirDados(nomeTabela: String, dados: Dictionary):
	db.inserirDados(nomeTabela, dados)


func deletarDado(nomeTabela: String, condicoes: String):
	db.deletarDados(nomeTabela, condicoes)


func atualizarDado(nomeTabela: String, condicoes: String, dados: Dictionary):
	db.atualizarDados(nomeTabela, condicoes, dados)
