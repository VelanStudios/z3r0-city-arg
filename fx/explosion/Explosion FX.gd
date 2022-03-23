extends AnimatedSprite

#temporary explosion effect

func _ready():
	play()

func _on_Explosion_FX_animation_finished():
	queue_free()
