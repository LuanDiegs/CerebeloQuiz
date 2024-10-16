extends HBoxContainer
class_name PorcentagemMotivoDenuncia

@onready var _nomeMotivoLabel = $NomeMotivo
@onready var _porcentagemDenunciaProgressBar = $PorcentagemDenuncia


func insereInformacoesMotivoPorcentagem(nomeMotivo: String, quantidadeTotal: int, quantidadeMotivo: int):
	_nomeMotivoLabel.text = nomeMotivo
	_porcentagemDenunciaProgressBar.max_value = quantidadeTotal
	_porcentagemDenunciaProgressBar.value = quantidadeMotivo
