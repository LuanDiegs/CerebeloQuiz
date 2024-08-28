extends CanvasLayer
class_name TransicaoDeCena

@onready var transicao = $Transicao
	
func trocar_cena(target: String) -> void:
	if(target != null):
		transicao.play("bloco_entra")
		await transicao.animation_finished
		get_tree().change_scene_to_file(target)
		transicao.play("bloco_sai")
