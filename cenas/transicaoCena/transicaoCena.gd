extends CanvasLayer
class_name TransicaoDeCena

@onready var transicao = $Transicao

const telaQuizzesPopulares := "res://cenas/quizzesPopulares/quizzesPopulares.tscn"
const telaPerguntasFrequentes := "res://cenas/perguntasFrequentes/perguntasFrequentes.tscn"
const telaLogin := "res://cenas/login/login.tscn"


func trocar_cena(target: String) -> void:
	if(target != null):
		var telaTargetComponente = load(target)
		var nomeTelaTarget = telaTargetComponente.instantiate().name if telaTargetComponente else null
		var nomeTelaAtual = get_tree().current_scene.name

		if(nomeTelaTarget and nomeTelaAtual != nomeTelaTarget):
			transicao.play("bloco_entra")
			await transicao.animation_finished
			get_tree().change_scene_to_file(target)
			transicao.play("bloco_sai")
