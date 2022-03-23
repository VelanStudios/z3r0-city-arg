extends AnimatedSprite

#--consts
const float_speed = 32

#--instance variables
var no_papap = false

func _ready():
	if no_papap:
		play("no_papap")
	else:
		play()
	$Timer.start()

func _process(delta):
	global_position.y -= float_speed * delta

func _on_Timer_timeout():
	queue_free()
