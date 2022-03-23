extends KinematicBody2D

#player control script

#--signals
signal defeated

#--constants
const SPEED = 256

#--exports
export (PackedScene) var normal_ball
export (AudioStream) var walking
export (AudioStream) var game_over

#--instance variables
var movement_input_map = ["move_up", "move_down", "move_left", "move_right"]
var throw_input_map = ["throw_up", "throw_down", "throw_left", "throw_right"]
var movement_vector_map = [Vector2.UP, Vector2.DOWN, Vector2.LEFT, Vector2.RIGHT]
var held_ball : PackedScene
var defeated = false
var score = 0
var movement_bonus = 1.0

func _ready():
	#start the player with a normal ball
	grab_ball(normal_ball)
	#start bgm
	bgm.play_bgm()

func _process(_delta):
	if !defeated:
		process_throw()

func _physics_process(_delta):
	if !defeated:
		process_movement()

#check if the player is trying to throw a ball
func process_throw():
	if held_ball:
		for i in range(throw_input_map.size()):
			if Input.is_action_just_pressed(throw_input_map[i]):
				var ball = held_ball.instance()
				get_parent().add_child(ball)
				held_ball = ball.throw(position, movement_vector_map[i])
				if !held_ball:
					$HeldBall.texture = null
				#multi-ball, pickup updated mutliball
				else:
					grab_ball(held_ball)
					ball.queue_free()
				break

#drop the currently held ball
func drop_ball():
	if held_ball:
		var ball = held_ball.instance()
		get_parent().add_child(ball)
		ball.drop(position)
		held_ball = null
		$HeldBall.texture = null
		movement_bonus = 1.0

#update the visual for the held ball
func grab_ball(ball : PackedScene):
	held_ball = ball
	#update heldball sprite
	var b = ball.instance()
	$HeldBall.texture = b.get_texture()
	b.queue_free()

#move the player in only one direction at a time
func process_movement():
	var moving = false
	for i in range(movement_input_map.size()):
		if Input.is_action_pressed(movement_input_map[i]):
			move_and_slide(movement_vector_map[i] * SPEED * movement_bonus)
			moving = true
			if !$AnimatedSprite.is_playing():
				$AnimatedSprite.play()
			if !$AudioStreamPlayer2D.playing:
				$AudioStreamPlayer2D.play()
			break
	if !moving:
		if $AnimatedSprite.is_playing():
			$AnimatedSprite.stop()
		if $AudioStreamPlayer2D.playing:
			$AudioStreamPlayer2D.stop()

#if overlapping a ball that can be grabbed, grab it
func _on_Area2D_body_entered(body):
	if body.is_in_group("Ball"):
		if body.can_grab:
			drop_ball()
			body.take_ball(self)
	elif body.is_in_group("Bot"):
		take_damage(1)

#play lose animation
func take_damage(_dmg):
	if !$AnimationPlayer.is_playing():
		defeated = true
		$AnimationPlayer.play("KO")
		$AudioStreamPlayer2D.stream = game_over
		$AudioStreamPlayer2D.play()

#game over, restart
func _on_AnimationPlayer_animation_finished(anim_name):
	global_position = Vector2(512, 512)
	emit_signal("defeated")
	defeated = false
	score = 0
	#restart bgm
	bgm.play_bgm()
	$AudioStreamPlayer2D.stream = walking
