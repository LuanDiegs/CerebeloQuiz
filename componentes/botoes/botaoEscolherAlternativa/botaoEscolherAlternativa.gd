extends Button
class_name BotaoEscolherAlternativa

@onready var alternativaTwitchLabel = $AlternativaTwitch
var alternativaTwitch: String

# Propriedades da alternativa
var isAlternativaCorreta: bool

func inserirLabelAlternativaTwitch(alternativaTwitch: String):
	alternativaTwitchLabel.visible = true
	alternativaTwitchLabel.text = alternativaTwitch
	self.alternativaTwitch = alternativaTwitch
