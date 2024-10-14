extends Button
class_name BotaoEscolherAlternativa

@onready var alternativaTwitchLabel = $AlternativaTwitch
var alternativaTwitch: String

# Propriedades da alternativa
var isAlternativaCorreta: bool
var _conteudoAlternativa := ""

func inserirLabelAlternativaTwitch(alternativaTwitch: String):
	alternativaTwitchLabel.visible = true
	alternativaTwitchLabel.text = alternativaTwitch
	self.alternativaTwitch = alternativaTwitch


func alteraOffsetPivotCentroComponente():
	self.pivot_offset.x = self.size.x/2
	self.pivot_offset.y = self.size.y/2


func insereTextoBotao(texto: String):
	_conteudoAlternativa = texto
	queue_redraw()


func _draw():
	self.text = str(_conteudoAlternativa.left(130))


func exibeAlternativaCorreta():
	var temaAlternativaCorreta = preload("res://componentes/botoes/botaoEscolherAlternativa/botaoEscolherAlternativaAlternativaCorreta.tres")
	self.disabled = true
	self.add_theme_stylebox_override("disabled", temaAlternativaCorreta)
