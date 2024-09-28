extends Node
class_name CursorTemas

const arrow = preload("res://resources/imagens/cursor/pointer_b.png")
const ibeam = preload("res://resources/imagens/cursor/ibeam.png")
const pointing = preload("res://resources/imagens/cursor/hand_small_point_n.png")

func _ready():
	Input.set_custom_mouse_cursor(arrow)
	Input.set_custom_mouse_cursor(ibeam, Input.CURSOR_IBEAM)
	Input.set_custom_mouse_cursor(pointing, Input.CURSOR_POINTING_HAND)