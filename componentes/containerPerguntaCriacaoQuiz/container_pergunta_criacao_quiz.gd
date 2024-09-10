extends MarginContainer
class_name ContainerPerguntaQuiz

var nodePego: ContainerPerguntaQuiz = null
var dragOffset = 0.0
var limiteDoContainer = 100

@onready var panelQuiz: PanelContainer = $PanelQuiz
@onready var vbox: VBoxContainer = self.get_parent()

@onready var botaoAgarrar = $PanelQuiz/MarginConteudo/Conteudos/BotaoAgarrar
@onready var _conteudoLabel: Label = $PanelQuiz/MarginConteudo/Conteudos/Conteudo

@onready var botaoEditar = $PanelQuiz/MarginConteudo/Conteudos/BotaoEditar

var idPergunta = 0
var conteudoPergunta = "" #"teste"
var alternativasConteudoSalvas: Array  #=[["a", true], ["b", false], ["v", false], ["c", false]]


func _ready() -> void:
	set_process_input(false)
	botaoEditar.connect("pressed", abrirFormPergunta)	


func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion or event is InputEventScreenDrag:
		nodePego.global_position.y = get_global_mouse_position().y - dragOffset
		if nodePego.global_position.y < global_position.y - limiteDoContainer:
			if self.get_index() > 0:
				vbox.move_child(self, self.get_index() - 1)
		elif nodePego.global_position.y > global_position.y + limiteDoContainer:
			if self.get_index() < vbox.get_child_count() - 1:
				vbox.move_child(self, self.get_index() + 1)
		
	if event.is_action_released("CliqueDireito"):
		panelQuiz.show()
		nodePego.queue_free()
		set_process_input(false)
	
	
func _on_botaoAgarrar_gui_input(event: InputEvent) -> void:
	if(event.is_action_pressed("CliqueDireito")):
		# Pega o node e cria uma cópia
		nodePego = self.duplicate()
		nodePego.set_script(null)
		vbox.get_parent().add_child(nodePego)
		dragOffset = get_global_mouse_position().y - global_position.y
		
		# Cria novo estilo
		var estiloPanelPego = panelQuiz.get_theme_stylebox("panel").duplicate()
		estiloPanelPego.shadow_color.a = 0.3
		estiloPanelPego.shadow_size = 8
		estiloPanelPego.shadow_offset = Vector2(3,3)
		
		# Coloca o estilo novo para falar que está sendo "pego", esconde o node "antigo"
		var panelPego: PanelContainer = nodePego.get_node("PanelQuiz")
		panelPego.add_theme_stylebox_override("panel", estiloPanelPego)
		panelQuiz.hide()
		set_process_input(true)
		
		nodePego.global_position = self.global_position


func _process(delta: float) -> void:
	_conteudoLabel.text = conteudoPergunta if !conteudoPergunta.is_empty() else "Pergunta sem conteúdo"
	botaoAgarrar.text = "Pergunta Nº " + str(self.get_index() + 1)
	

func abrirFormPergunta():
	var titulo = "Nova pergunta" if idPergunta == 0 else "Editar pergunta"
	PopUp.criaPopupEditFormPergunta(titulo, self)
