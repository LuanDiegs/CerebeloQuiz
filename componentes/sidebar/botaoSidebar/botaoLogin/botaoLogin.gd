extends Button
class_name BotaoLogin


func _ready():
	self.connect("pressed", onClick)


func _process(_delta):
	if(SessaoUsuario.isLogada):
		self.text = "DESLOGAR"
	else:
		self.text = "LOGIN"


func onClick():
	if(!SessaoUsuario.isLogada):
		TransicaoCena.trocar_cena(TransicaoCena.telaLogin)
	else:
		PopUp.criaPopupConfirmacao(
			SessaoUsuario.usuarioLogado.nomeUsuario + " certeza que deseja sair da sua sessão?",
			"Atenção",
			"Cancelar",
			Utils.criaBotaoAdicional("Confirmar", _deslogar))
		

func _deslogar():
	SessaoUsuario.sessaoDesativada()
	TransicaoCena.trocar_cena(TransicaoCena.telaQuizzesPopulares)
