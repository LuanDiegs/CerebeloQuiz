extends Control
class_name BotaoToggle

@export var textoOpcao1: String = "Opção 1"
@export var textoOpcao2: String = "Opção 2"
@export var valorOpcao1: int = 0
@export var valorOpcao2: int = 0
@export var labelTexto: String = "Label"

@onready var botaoOpcao1: Button = $ContainerBotoes/Opcao1
@onready var botaoOpcao2: Button = $ContainerBotoes/Opcao2
@onready var labelTituloInput: Label = $LabelTituloInput


func _ready() -> void:
	botaoOpcao1.text = textoOpcao1
	botaoOpcao2.text = textoOpcao2
	labelTituloInput.text = labelTexto


func obterValorSelecionado():
	if(botaoOpcao1.button_pressed):
		return valorOpcao1
	
	if(botaoOpcao2.button_pressed):
		return valorOpcao2


func insereValor(valor: bool):
	if(!valor):
		botaoOpcao1.button_pressed = true
	else:
		botaoOpcao2.button_pressed = true
