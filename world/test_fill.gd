extends TileMap

#randomly fill the map with tiles and save it to a separate level
#this script is removed when shipped so there isn't an indicator in the code which spot in the grid is an answer

var banlist = [
	Vector2(-7, 6),
	Vector2(-15, -4),
	Vector2(3, 1),
	Vector2(4, 30),
	Vector2(-1, 1)
]

func _ready():
	random_fill()
	save_level()

func random_fill():
	for x in range(-512, 512):
		if ((x>=0 && x%8!=0 && x%8!=7) || (x<0 && x%8!=-1 && x%8!=0)):
			for y in range(-512, 512):
				if ((y>=0 && y%8!=0 && y%8!=7) || (y<0 && y%8!=-1 && y%8!=0)):
					if (!is_banned(Vector2(x, y))):
						if (randi()%3 == 1):
							set_cell(x, y, 0)
						else:
							set_cell(x, y, -1)

#parse coord to directions
func is_banned(coord):
	var parsed_coord = coord/8
	parsed_coord.x = floor(parsed_coord.x)
	parsed_coord.y = floor(parsed_coord.y)
	
	if (banlist.has(parsed_coord)):
		print(str("Banned coord: ", coord, " | ", parsed_coord, " | ", floor(coord.x/8)))
	
	return banlist.has(parsed_coord)

func save_level():
	var packed_scene = PackedScene.new()
	packed_scene.pack(self)
	ResourceSaver.save("res://new_world.tscn", packed_scene)
