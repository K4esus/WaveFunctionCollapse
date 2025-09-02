extends TileMapLayer

# the amout of tiles that fit into the screen
var screen_width = 20
var screen_heigth = 12

# checks if all tiles are painted
var set_tiles_counter = 0
var tiles = []
var tile_rules = Tile_Rules.new()
var smallest_entropy = []
var tick = 0
var already_placed = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for x in screen_width:
		var row = []
		for y in screen_heigth:
			var new_tile = Tile.new()
			new_tile.create(tile_rules.rules.keys())
			new_tile.position = Vector2i(x,y)
			var current_tile = get_cell_atlas_coords(new_tile.position)
			if current_tile != Vector2i(-1,-1):
				new_tile.current_tile = current_tile.y
				new_tile.collapse()
				already_placed.append(new_tile)
			row.append(new_tile)
		tiles.append(row)
	for tile in already_placed:
		collapse_surrounding_tiles(tile.position.x, tile.position.y)
		set_tiles_counter += 1
	find_lowest_entropy()
	while set_tiles_counter < (screen_heigth*screen_width):
		set_tile()
		find_lowest_entropy()


func _physics_process(delta: float) -> void:
	return
	if set_tiles_counter < (screen_heigth*screen_width):
		#print(smallest_entropy)
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
	if event is InputEventMouseButton and event.is_pressed():
		var local_mouse_pos = to_local(get_global_mouse_position())
		var clicked_cell = local_to_map(local_mouse_pos)
		var cell_type = get_cell_atlas_coords(clicked_cell)
		print(clicked_cell)
		print(cell_type)
	return
	

func set_tile():
	var next_tile = smallest_entropy.pick_random()
	var pick = tiles[next_tile.x][next_tile.y].pick_random_possibility()
	if !pick and pick != 0:
		set_cell(Vector2(next_tile.x,next_tile.y), 2, Vector2(-1,-1))
		set_tiles_counter += 1
		return
	set_cell(Vector2(next_tile.x,next_tile.y), 2, Vector2(0,pick))
	set_tiles_counter += 1
	collapse_surrounding_tiles(next_tile.x,next_tile.y)


func find_lowest_entropy():
	var dict := {}
	for i in tile_rules.rules.keys():
		dict[i] = []
	
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


func collapse_surrounding_tiles(tile_x, tile_y):
	var center_tile = tiles[tile_x][tile_y].current_tile
	var center_tile_rule = tile_rules.rules[center_tile]
	
	const up = 0
	const right = 1
	const down = 2
	const left = 3
	
	var left_pos = []
	if tile_x > 0:
		var left_tile = tiles[tile_x - 1][tile_y]
		for pos_tile in tile_rules.rules.keys():
			if center_tile_rule[left] == tile_rules.rules[pos_tile][right]:
				left_pos.append(pos_tile)
		left_tile.merge_possibilitys(left_pos)
		
	
	var right_pos = []
	if tile_x < screen_width-1:
		var right_tile = tiles[tile_x + 1][tile_y]
		for pos_tile in tile_rules.rules.keys():
			if center_tile_rule[right] == tile_rules.rules[pos_tile][left]:
				right_pos.append(pos_tile)
		right_tile.merge_possibilitys(right_pos)
		
	var up_pos = []
	if tile_y > 0:
		var up_tile = tiles[tile_x][tile_y - 1]
		for pos_tile in tile_rules.rules.keys():
			if center_tile_rule[up] == tile_rules.rules[pos_tile][down]:
				up_pos.append(pos_tile)
		up_tile.merge_possibilitys(up_pos)
	
	
	var down_pos = []
	if tile_y < screen_heigth-1:
		var down_tile = tiles[tile_x][tile_y + 1]
		for pos_tile in tile_rules.rules.keys():
			if center_tile_rule[down] == tile_rules.rules[pos_tile][up]:
				down_pos.append(pos_tile)
		down_tile.merge_possibilitys(down_pos)
