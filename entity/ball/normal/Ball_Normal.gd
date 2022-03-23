extends RigidBody2D

#all balls inherit from this script to inherit common functions

#--exports
export (AudioStream) var pickup_sound

#--consts
const THROW_IMPULSE = 360
const DROP_MULTIPLIER = 0.1
const MIN_HURT = 250

#--instance variables
var speed_multiplier = 1.0
var can_grab = true
var dropped = false

#throw the ball in the given direction
func throw(from, dir):
	linear_velocity = Vector2.ZERO
	can_grab = false
	position = from
	apply_central_impulse(dir * THROW_IMPULSE * speed_multiplier)
	$Timer.start()
	return null

#throw the ball in the given direction
func drop(from):
	linear_velocity = Vector2.ZERO
	dropped = true
	can_grab = false
	position = from
	var dir = Vector2(rand_range(-1.0, 1.0), rand_range(-1.0, 1.0)).normalized()
	apply_central_impulse(dir * THROW_IMPULSE * DROP_MULTIPLIER)
	$Timer.start()

#returns the texture of the ball
func get_texture():
	return $Sprite.texture

#sets the texture of the ball
func set_texture(texture):
	$Sprite.texture = texture

#give this ball to the player
func take_ball(player):
	var ball = PackedScene.new()
	ball.pack(self)
	player.grab_ball(ball)
	play_grab_sound()
	queue_free()

#wait a bit before letting the player pick us up
func _on_Timer_timeout():
	can_grab = true
	dropped = false

#returns if the velocity is beyond the hurt threshold
func can_hurt():
	return linear_velocity.length() >= MIN_HURT

#plays the ground sound effect
func play_grab_sound():
	var sfx = bgm.sfx_scene.instance()
	get_parent().add_child(sfx)
	sfx.play_sfx(pickup_sound, global_position)
