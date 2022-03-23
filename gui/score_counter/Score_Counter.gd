extends Label

#--instance variables
var player

func _ready():
	player = get_tree().get_nodes_in_group("Player")[0]

func _process(_delta):
	text = str(player.score)
