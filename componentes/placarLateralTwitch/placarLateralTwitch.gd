extends PanelContainer
class_name PlacarLateralTwitch

@onready var posicaoLabel = $MarginItem/ItensDoPlacar/Posicao
@onready var nomeLabel = $MarginItem/ItensDoPlacar/Nome
@onready var pontuacaoLabel = $MarginItem/ItensDoPlacar/Pontuacao


func inserePlacar(posicao: int, nome: String, placar: int):
	posicaoLabel.text = str(posicao)
	nomeLabel.text = str(nome)
	pontuacaoLabel.text = str(placar)
