extends Node2D

#--signals
signal pet

#--exports
export (PackedScene) var reaction
export (PackedScene) var pet_effect

#--consts
const ABOVE = 16
const PLEASE_PET = 42
const TITLES = ["Amazing", "Handsome", "Beautiful", "Awesome", "Supreme", "Gorgeous", "Intelligent", "Genius"]
const PETTER = "PETTER"

#--instance variables
var pets = 0
var pets_this_session = 0

func _ready():
	connect("pet", get_tree().get_nodes_in_group("Reward")[0], "chonky_pet")

func _process(_delta):
	for b in $Area2D.get_overlapping_bodies():
		if b.is_in_group("Player"):
			if Input.is_action_just_pressed("pet"):
				emit_signal("pet")
				var pet = pet_effect.instance()
				pet.position.y -= ABOVE
				add_child(pet)
				pets += 1
				pets_this_session += 1
				#pet check
				if pets % PLEASE_PET == 0:
					pass

#begin counting pets
func _on_Pet_Range_body_entered(body):
	pets_this_session = 0

#check if the player pet chonky
func _on_Pet_Range_body_exited(body):
	var hearts = reaction.instance()
	if pets_this_session <= 0:
		hearts.no_papap = true
	add_child(hearts)
