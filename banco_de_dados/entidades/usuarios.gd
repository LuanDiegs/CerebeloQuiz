extends EntidadeBase
class_name Usuarios

var dadoAInserir: Dictionary

func _init(nome: String, email: String, senha: String, dataNascimento: String, telefone: int):
	self.dadoAInserir = {
		"nome": nome,
		"email": email,
		"senha": senha,
		"datanascimento": dataNascimento,
		"telefone": telefone,
		"isdesativado": false,
	}
