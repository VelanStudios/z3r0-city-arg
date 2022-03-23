extends Node2D

#manages the spawning of balls and enemies when entering a new room

#--exports
export (PackedScene) var ball_normal
export (PackedScene) var ball_multi
export (PackedScene) var ball_sniper
export (PackedScene) var ball_moon
export (PackedScene) var ball_bomb
export (PackedScene) var bot_spawner

#--const
const MIN_BALL = 1
const MAX_BALL = 3
const MIN_BOT = 1
const MAX_BOT = 4

#--instance variabes
#list of non-expendable balls (i.e not bomb)
var forced_balls : Array
#list of all spawnable balls
var all_balls : Array
#rngesus
var rng : RandomNumberGenerator = RandomNumberGenerator.new()

func _ready():
	rng.randomize()
	forced_balls = [ball_normal, ball_multi, ball_sniper, ball_moon]
	all_balls = [ball_normal, ball_multi, ball_sniper, ball_moon, ball_bomb]

#go through the current screen and spawn a minimum number of items
func spawn_items_in_room():
	clear_items()
	var world_grid = get_tree().get_nodes_in_group("World_Grid")[0]
	var open_spaces : Array = get_open_spaces(world_grid)
	var half_cell = world_grid.cell_size/2
	#spawn minimum bots and balls
	for i in range(rng.randi_range(MIN_BALL, MAX_BALL)):
		var index = randi() % open_spaces.size()
		var pos = open_spaces[index]
		var world_pos = world_grid.map_to_world(pos) + half_cell
		#first ball be non-expendable
		if (i <= 0):
			spawn_forced_ball(world_pos)
		else:
			spawn_ball(world_pos)
		open_spaces.remove(index)
	for i in range(rng.randi_range(MIN_BOT, MAX_BOT)):
		var index = randi() % open_spaces.size()
		var pos = open_spaces[index]
		var world_pos = world_grid.map_to_world(pos) + half_cell
		spawn_bot_spawner(world_pos)
		open_spaces.remove(index)

#spawn one of each type of ball in the room
func spawn_balls_in_room():
	clear_items()
	var world_grid = get_tree().get_nodes_in_group("World_Grid")[0]
	var open_spaces : Array = get_open_spaces(world_grid)
	var half_cell = world_grid.cell_size/2
	#spawn minimum bots and balls
	for i in range(all_balls.size()):
		var index = randi() % open_spaces.size()
		var pos = open_spaces[index]
		var world_pos = world_grid.map_to_world(pos) + half_cell
		#first ball be non-expendable
		spawn_ball(world_pos, i)
		open_spaces.remove(index)

#clear the world of other balls, bots, and bot spawners
func clear_items():
	var balls = get_tree().get_nodes_in_group("Ball")
	for b in balls:
		b.queue_free()
	var bots = get_tree().get_nodes_in_group("Bot")
	for b in bots:
		b.queue_free()
	var spawners = get_tree().get_nodes_in_group("Bot_Spawner")
	for s in spawners:
		s.queue_free()

#returns a list of all open spaces in the current room not on the border
func get_open_spaces(world_grid) -> Array:
	var grid_size = world_grid.cell_size.x
	var open_spaces : Array
	for i in range(1, 7):
		for j in range(1, 7):
			var pos = Vector2(i * grid_size, j * grid_size) + global_position
			var grid_pos = world_grid.world_to_map(pos)
			if world_grid.get_cell(grid_pos.x, grid_pos.y) < 0:
				open_spaces.append(grid_pos)
	return open_spaces

#spawns a forced ball at the given position
func spawn_forced_ball(world_pos):
	var ball = forced_balls[randi() % forced_balls.size()]
	var e = ball.instance()
	e.global_position = world_pos
	get_parent().get_parent().add_child(e)

#spawns a ball at the given position
func spawn_ball(world_pos, choose_ball=-1):
	var ball
	if choose_ball < 0:
		ball = all_balls[randi() % all_balls.size()]
	else:
		ball = all_balls[choose_ball]
	var e = ball.instance()
	e.global_position = world_pos
	get_parent().get_parent().add_child(e)

#spawns a bot spawner at the given position
func spawn_bot_spawner(world_pos):
	var e = bot_spawner.instance()
	e.global_position = world_pos
	get_parent().get_parent().add_child(e)
