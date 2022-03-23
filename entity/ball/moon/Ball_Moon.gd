extends "res://entity/ball/normal/Ball_Normal.gd"

#--consts
const MOVEMENT_BONUS = 1.2

func _ready():
	speed_multiplier = 1.2

#speed bonus for moon ball
func take_ball(player):
	.take_ball(player)
	player.movement_bonus = MOVEMENT_BONUS
