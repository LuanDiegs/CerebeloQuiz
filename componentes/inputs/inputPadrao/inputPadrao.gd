extends LineEdit
class_name InputPadrao

@export var placeholder: String
@export var labelTexto: String

@onready var label_input: Label = $LabelInput

func _ready() -> void:
	if(!placeholder.is_empty()):
		self.placeholder_text = placeholder
	
	if(!labelTexto.is_empty()):
		label_input.text = labelTexto
	
