extends LineEdit
class_name InputPadrao

@export var placeholder: String
@export var labelTexto: String
@export var labelErroTexto: String

@onready var labelInput: Label = $LabelInput
@onready var labelErro: Label = $LabelInput/labelErro

func _ready() -> void:
	if(!placeholder.is_empty()):
		self.placeholder_text = placeholder
	
	if(!labelTexto.is_empty()):
		labelInput.text = labelTexto
	

func insereErroNoInput(erro: String):
	labelErro.visible = true
	labelErro.text = erro
	
	
func removeErroNoInput():
	labelErro.visible = false
	labelErro.text = ""
