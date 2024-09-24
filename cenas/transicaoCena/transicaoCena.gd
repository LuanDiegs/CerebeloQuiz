extends CanvasLayer
class_name TransicaoDeCena

@onready var transicao = $Transicao

const telaQuizzesPopulares := "res://cenas/quizzesPopulares/quizzesPopulares.tscn"
const telaPerguntasFrequentes := "res://cenas/perguntasFrequentes/perguntasFrequentes.tscn"
const telaLogin := "res://cenas/login/login.tscn"
const telaEditFormQuiz := "res://cenas/criarQuiz/criarQuiz.tscn"
const telaMeusQuizzes := "res://cenas/meusQuizzes/meusQuizzes.tscn"
const telaResponderQuiz := "res://cenas/responderQuiz/responderQuiz.tscn"
const telaResponderQuizTwitch := "res://cenas/responderQuizTwitch/respondeQuizTwitch.tscn"


func trocar_cena(target: String, idRegistroEdicao: int = 0, quizId: int = 0) -> void:
	if(target != null):
		var telaTargetComponente: PackedScene = load(target)
		var telaATrocar = telaTargetComponente
		var nomeTelaTarget = telaTargetComponente.instantiate().name if telaTargetComponente else null
		var nomeTelaAtual = get_tree().current_scene.name

		if(nomeTelaTarget and nomeTelaAtual != nomeTelaTarget):
			transicao.play("bloco_entra")
			await transicao.animation_finished
			
			#Verifica se o componente tem a propriedade idRegistroEdicao
			#E coloca o valor (se for passado)
			var telaInstanciada = telaTargetComponente.instantiate()
			var telaModificada: PackedScene = PackedScene.new()
			if("idRegistroEdicao" in telaInstanciada):
				telaInstanciada.idRegistroEdicao = idRegistroEdicao
				telaModificada.pack(telaInstanciada)
				telaATrocar = telaModificada
			
			#Insere o quizId se tiver
			if("quizId" in telaInstanciada):
				telaInstanciada.quizId = quizId
				telaModificada.pack(telaInstanciada)
				telaATrocar = telaModificada

			get_tree().change_scene_to_packed(telaATrocar)
			transicao.play("bloco_sai")
