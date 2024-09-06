extends Button
class_name BotaoLogin


func _ready():
	self.connect("pressed", onClick)


func _process(delta):
	if(SessaoUsuario.isLogada):
		self.text = "DESLOGAR"
	else:
		self.text = "LOGIN"

func onClick():
	if(!SessaoUsuario.isLogada):
		TransicaoCena.trocar_cena(TransicaoCena.telaLogin)
	else:
		SessaoUsuario.sessaoDesativada()
		TransicaoCena.trocar_cena(TransicaoCena.telaQuizzesPopulares)
