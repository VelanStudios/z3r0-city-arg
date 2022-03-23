extends Node2D

func chonky_pet():
	var chonky : bool = false
	for a in $Area2D.get_overlapping_areas():
		if a.is_in_group("Chonky"):
			chonky = true
	if chonky:
		$Label.show()
