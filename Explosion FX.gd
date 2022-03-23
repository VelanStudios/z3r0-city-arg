extends AnimatedSprite

#Extremely high fidelity explosion effect
#TODO: causes extremely poor performance on low end machines, prompt user to download more ram?

func _ready():
	play()

func _on_Explosion_FX_animation_finished():
	queue_free()
