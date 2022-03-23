extends KinematicBody2D

#Enemy that chases the player using rudimentary pathfinding
#A* is integrated into Godot, however it would be overkill for this and
#a bit of slop in the pathfinding gives it that 'old school' charm :)

#--export
export (PackedScene) var explosion_fx

#--const
const CAST_LENGTH = 128
const SPEED = 128
const MAX_TRIES = 8
const TRY_ANGLE = 45

#--onready variables
onready var player = get_tree().get_nodes_in_group("Player")[0]
onready var direction = Vector2.ZERO

func _ready():
	_on_Timer_timeout()
	$Timer.start()

func _physics_process(_delta):
	process_movement()

#move in the assigned direction
func process_movement():
	if direction.length() != 0:
		move_and_slide(direction * SPEED)

#attempt to move toward the player, if blocked circle around
func _on_Timer_timeout():
	var space_state = get_world_2d().direct_space_state
	$Timer.start()
	var dir = player.position.angle_to_point(position)
	#turn the vector MAX_TRIES times
	for i in range(MAX_TRIES):
		var n_dir = dir + (i * deg2rad(TRY_ANGLE))
		var v_dir = Vector2(cos(n_dir), sin(n_dir))
		var result = space_state.intersect_ray(global_position, global_position + v_dir * CAST_LENGTH,
			[self], 0x1)
		if !result:
			direction = v_dir
			return
	#stand still if can't move within max tries
	direction = Vector2.ZERO

#collision detection
func _on_Area2D_body_exited(body):
	if body.is_in_group("Ball"):
		if body.can_hurt():
			take_damage(99)

#take damage
func take_damage(_dmg):
	var e = explosion_fx.instance()
	e.global_position = global_position
	get_parent().add_child(e)
	#give the player a point
	get_tree().get_nodes_in_group("Player")[0].score += 1
	queue_free()
