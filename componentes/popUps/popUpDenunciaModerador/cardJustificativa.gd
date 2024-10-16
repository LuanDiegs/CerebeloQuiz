extends MarginContainer
class_name CardJustificativa

@onready var _justificativaLabel = $PanelCardJustificativa/MarginInternaCardQuiz/ItensCardJustificativa/Justificativa
@onready var _nomeDeUsuarioLabel = $PanelCardJustificativa/MarginInternaCardQuiz/ItensCardJustificativa/NomeDeUsuario

func insereInformacoesPrincipais(justificativa: String, nomeDeUsuario: String):
	_justificativaLabel.text = justificativa
	_nomeDeUsuarioLabel.text = "Por: " + nomeDeUsuario
	
