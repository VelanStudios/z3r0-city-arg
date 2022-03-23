extends Node2D

#tracks the player in the grid

#--onready
onready var vp_rect = get_viewport().size
	
func _ready():
	var player = get_tree().get_nodes_in_group("Player")[0]
	player.connect("defeated", self, "reset")

#reset camera
func reset():
	global_position = Vector2(512, 512)
	$Spawn_Manager.spawn_balls_in_room()

func _on_Area2D_Up_body_entered(_body):
	position.y -= vp_rect.y
	#spawn items in the new room
	$Spawn_Manager.spawn_items_in_room()

func _on_Area2D_Down_body_entered(_body):
	position.y += vp_rect.y
	#spawn items in the new room
	$Spawn_Manager.spawn_items_in_room()

func _on_Area2D_Left_body_entered(_body):
	position.x -= vp_rect.x
	#spawn items in the new room
	$Spawn_Manager.spawn_items_in_room()

func _on_Area2D_Right_body_entered(_body):
	position.x += vp_rect.x
	#spawn items in the new room
	$Spawn_Manager.spawn_items_in_room()
