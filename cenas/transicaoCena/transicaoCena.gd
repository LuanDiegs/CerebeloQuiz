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

@onready var _nomesTelasConfirmarSaida := [
	ConstantesPadroes.NOME_TELA_RESPONDER_QUIZ.to_lower(),
	ConstantesPadroes.NOME_TELA_CRIAR_EDITAR_QUIZ.to_lower()]

func trocar_cena(
		target: String, 
		idRegistroEdicaoPropriedade: int = 0, 
		quizIdPropriedade: int = 0, 
		confirmado: bool = false) -> void:
	if(target != null):
		var telaTargetComponente: PackedScene = load(target)
		var telaATrocar = telaTargetComponente
		var nomeTelaTarget = telaTargetComponente.instantiate().name if telaTargetComponente else null
		var nomeTelaAtual = get_tree().current_scene.name
	
		#Verifica se a tela tema funcao atualizaGridQuizzes
		if(get_tree().current_scene.has_method("atualizarGridQuizzes")):
			get_tree().current_scene.atualizarGridQuizzes()
			
		if(nomeTelaTarget and nomeTelaAtual != nomeTelaTarget):
			#Verifica se precisa de confirmaçao para sair da tela
			if(_nomesTelasConfirmarSaida.has(nomeTelaAtual.to_lower()) and !confirmado):
				confirmarTrocarCena("Deseja realmente sair?", "Eita...", target)
				return

			transicao.play("bloco_entra")
			await transicao.animation_finished
			
			#Verifica se o componente tem a propriedade idRegistroEdicao
			#E coloca o valor (se for passado)
			var telaInstanciada = telaTargetComponente.instantiate()
			var telaModificada: PackedScene = PackedScene.new()
			if("idRegistroEdicao" in telaInstanciada):
				telaInstanciada.idRegistroEdicao = idRegistroEdicaoPropriedade
				telaModificada.pack(telaInstanciada)
				telaATrocar = telaModificada
			
			#Insere o quizId se tiver
			if("quizId" in telaInstanciada):
				telaInstanciada.quizId = quizIdPropriedade
				telaModificada.pack(telaInstanciada)
				telaATrocar = telaModificada

			get_tree().change_scene_to_packed(telaATrocar)
			transicao.play("bloco_sai")


func confirmarTrocarCena(texto: String, titulo: String, cenaATrocar: String):
	PopUp.criaPopupConfirmacao(
		texto, 
		titulo, 
		"Cancelar", 
		[Utils.criaBotaoAdicional("Confirmar", func(): trocar_cena(cenaATrocar, 0, 0, true))])
