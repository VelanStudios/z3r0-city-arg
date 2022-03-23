extends "res://entity/ball/normal/Ball_Normal.gd"

#--exports
export (Texture) var multi_1_texture
export (Texture) var multi_2_texture
export (Texture) var multi_3_texture
export (Texture) var multi_hold_2_texture
export (Texture) var multi_hold_3_texture
export (PackedScene) var ball
export var balls = 3


func _ready():
	set_texture_drop()

#throw a single multiball in the given direction
func throw(from, dir):
	var b = ball.instance()
	get_parent().add_child(b)
	b.throw(from, dir)
	b.set_texture(multi_1_texture)
	balls -= 1
	#if out of balls return null
	if (balls <= 0):
		queue_free()
		return null
	#otherwise return self, packed
	set_texture_held()
	var ball = PackedScene.new()
	ball.pack(self)
	return ball

#set the texture of this ball drop based on how many balls this multi has
func set_texture_drop():
	match balls:
		3:
			$Sprite.texture = multi_3_texture
		2:
			$Sprite.texture = multi_2_texture
		_:
			$Sprite.texture = multi_1_texture

#set the texture of this ball based on how many balls this multi has
func set_texture_held():
	match balls:
		3:
			$Sprite.texture = multi_hold_3_texture
		2:
			$Sprite.texture = multi_hold_2_texture
		_:
			$Sprite.texture = multi_1_texture

#give this ball to the player
func take_ball(player):
	set_texture_held()
	.take_ball(player)

#returns the texture of the ball based on how many balls this mutli has
func get_texture():
	return $Sprite.texture
