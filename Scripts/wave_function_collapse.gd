extends TileMapLayer

var rng = RandomNumberGenerator.new()
var screen_width = 72
var screen_heigth = 41

var set_tiles_counter = 0
var tiles = []
var tile_rules = Tile_Rules.new()
var smallest_entropy = []
var tick = 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for x in screen_width:
		var row = []
		for y in screen_heigth:
			var new_tile = Tile.new()
			new_tile.position = Vector2(x,y)
			row.append(new_tile)
		tiles.append(row)
	find_lowest_entropy()


func _physics_process(delta: float) -> void:
	#return
	if set_tiles_counter < (screen_heigth*screen_width):
		print(smallest_entropy)
		set_tile()
		find_lowest_entropy()

func restart():
	tick = 0
	tiles = []
	smallest_entropy = []
	set_tiles_counter = 0
	for x in screen_width:
		var row = []
		for y in screen_heigth:
			var new_tile = Tile.new()
			new_tile.position = Vector2(x,y)
			row.append(new_tile)
		tiles.append(row)
	find_lowest_entropy()

func _input(event: InputEvent) -> void:
	return
	if event is InputEventMouseButton and event.is_pressed():
		if set_tiles_counter < (screen_heigth*screen_width):
			print("Tick ", tick)
			tick += 1
			set_tile()
			find_lowest_entropy()

func set_tile():
	var next_tile = smallest_entropy.pick_random()
	#print("smallest entropy ",smallest_entropy)
	#print("next tile ",next_tile)
	#print("possible tiles ",tiles[next_tile.x][next_tile.y].possible_tiles)
	var pick = tiles[next_tile.x][next_tile.y].pick_random_possibility()
	if !pick and pick != 0:
		#print(tiles[next_tile.x][next_tile.y].possible_tiles)
		#print("pick is Nil")
		set_cell(Vector2(next_tile.x,next_tile.y), 1, Vector2(0,0))
		set_tiles_counter += 1
		return
	set_cell(Vector2(next_tile.x,next_tile.y), 2, Vector2(0,pick))
	set_tiles_counter += 1
	collapse_surrounding_tiles(next_tile.x,next_tile.y)
	

func collapse_surrounding_tiles(tile_x, tile_y):
	var center_tile = tiles[tile_x][tile_y]
	#print("current tile ", center_tile)
	if tile_x > 0:
		var left_tile = tiles[tile_x - 1][tile_y]
		var left_possibilitys = tile_rules.rules[center_tile.current_tile]["left"]
		#print("left ", left_possibilitys)
		#print(left_tile.position)
		left_tile.merge_possibilitys(left_possibilitys)
		
	
	if tile_x < screen_width-1:
		var right_tile = tiles[tile_x + 1][tile_y]
		var right_possibilitys = tile_rules.rules[center_tile.current_tile]["right"]
		#print("right ",right_possibilitys)
		#print(right_tile.position)
		right_tile.merge_possibilitys(right_possibilitys)
	
	if tile_y > 0:
		var up_tile = tiles[tile_x][tile_y - 1]
		var up_possibilitys = tile_rules.rules[center_tile.current_tile]["up"]
		#print("up ", up_possibilitys)
		#print(up_tile.position)
		up_tile.merge_possibilitys(up_possibilitys)
		
	if tile_y < screen_heigth-1:
		var down_tile = tiles[tile_x][tile_y + 1]
		var down_possibilitys = tile_rules.rules[center_tile.current_tile]["down"]
		#print("down",down_possibilitys)
		#print(down_tile.position)
		down_tile.merge_possibilitys(down_possibilitys)
		
		
func find_lowest_entropy():
	var dict := {
		0:[],
		1:[],
		2:[],
		3:[],
		4:[],
		5:[],
	}
	
	for x in screen_width:
		for y in screen_heigth:
			if not tiles[x][y].collapsed:
				dict[tiles[x][y].entropy].append(tiles[x][y].position)
	var small = []
	for key in dict.keys():
		if len(dict[key]) > 0:
			#print("Entropy ", key)
			small = dict[key]
			break
	smallest_entropy = small
	#print(smallest_entropy)
