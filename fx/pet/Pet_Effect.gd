extends Node2D

#--const
const RANGE = 16

func _ready():
	position += Vector2(rand_range(-RANGE, RANGE), rand_range(-RANGE, RANGE))
	$Timer.start()

func _on_Timer_timeout():
	queue_free()
