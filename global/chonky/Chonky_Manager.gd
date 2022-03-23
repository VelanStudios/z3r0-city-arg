extends Node

#In truth, nothing can manager chonky
#This is more of a chonky "summoner"

#--exports
export (PackedScene) var the_boi

#--instance variables
var state = 0
var spawned = false

func _input(event):
	if event is InputEventKey and event.is_pressed() and not event.is_echo():
		var check_for
		match state:
			0:
				check_for = KEY_C
			1:
				check_for = KEY_H
			2:
				check_for = KEY_O
			3:
				check_for = KEY_N
			4:
				check_for = KEY_K
			_:
				check_for = KEY_Y
		if event.scancode == check_for:
			state += 1
			if state >= 5 and !spawned:
				var chonky = the_boi.instance()
				get_tree().get_nodes_in_group("World")[0].add_child(chonky)
				chonky.global_position = get_tree().get_nodes_in_group("Player")[0].global_position
				spawned = true
		else:
			state = 0
		
