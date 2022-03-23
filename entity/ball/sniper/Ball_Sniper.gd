extends "res://entity/ball/normal/Ball_Normal.gd"

func _ready():
	speed_multiplier = 3.5

#keep the ball facing the direction it was thrown
func throw(from, dir):
	rotation = dir.angle()
	.throw(from, dir)
