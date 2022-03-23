extends AnimatedSprite

#--exports
export (PackedScene) var bot

func _ready():
	play()

#craete an instance of a bot at the spawner location
func _on_Bot_Spawner_animation_finished():
	var e = bot.instance()
	e.global_position = global_position
	get_parent().add_child(e)
	queue_free()
