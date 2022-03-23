extends Node

#--exports
export (AudioStream) var bsb_intro
export (AudioStream) var bsb_loop

#--instance vars
var sfx_scene = preload("res://fx/sfx/SFX.tscn")

func play_bgm():
	$AudioStreamPlayer.stream = bsb_intro
	$AudioStreamPlayer.play()

func _on_AudioStreamPlayer_finished():
	if $AudioStreamPlayer.stream == bsb_intro:
		$AudioStreamPlayer.stream = bsb_loop
		$AudioStreamPlayer.play()
