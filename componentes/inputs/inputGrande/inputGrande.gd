extends LineEdit
class_name InputGrande

@export var placeholder: String

func _ready() -> void:
	if(!placeholder.is_empty()):
		self.placeholder_text = placeholder
	
