extends BotaoMenuSidebar
class_name BotaoCriarQuizz

@export var iconBotaoCriarQuiz: TextureRect

func _on_hover():

	if (iconBotaoCriarQuiz != null):
		if(!self.is_hovered()):
			var tween = create_tween().set_loops()
		
			tween.tween_property(iconBotaoCriarQuiz, "position", Vector2(iconBotaoCriarQuiz.position.x, 125), 0.5).set_ease(Tween.EASE_IN_OUT)
			tween.tween_property(iconBotaoCriarQuiz, "position", Vector2(iconBotaoCriarQuiz.position.x, 135), 0.5).set_ease(Tween.EASE_IN_OUT)
