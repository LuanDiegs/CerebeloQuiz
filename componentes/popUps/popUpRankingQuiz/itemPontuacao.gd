extends VBoxContainer
class_name ItemPontuacaoRanking

@onready var _nomeLabel = $InformacoesPontuacao/Nome
@onready var _pontuacaoLabel = $InformacoesPontuacao/Pontuacao

func inserePontuacaoEUsuario(usuarioNome: String, pontuacaoDoUsuario: int):
	_nomeLabel.text = usuarioNome
	_pontuacaoLabel.text = str(pontuacaoDoUsuario)
