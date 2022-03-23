extends AudioStreamPlayer2D

func play_sfx(new_stream, pos):
	stream = new_stream
	play()
	global_position = pos

func _on_AudioStreamPlayer2D_finished():
	queue_free()
