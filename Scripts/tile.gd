class_name Tile

var rng = RandomNumberGenerator.new()
var possible_tiles = []
var collapsed = false
var entropy = -1
var current_tile = -1
var position: Vector2i
var max_tile_num = -1

func create(tiles):
	possible_tiles = tiles
	entropy = len(possible_tiles)-1
	max_tile_num = len(possible_tiles)

func collapse():
	if current_tile != -1:
		collapsed = true

func pick_random_possibility():
	var pick = possible_tiles.pick_random()
	
	collapsed = true
	current_tile = pick
	return pick

func merge_possibilitys(pos: Array):
	var dict := {}
	for i in range(max_tile_num):
		dict[i] = 0
	for a in pos:
		dict[a] += 1
	for a in possible_tiles:
		dict[a] += 1
	var new_tiles = []
	for key in dict.keys():
		if dict[key] > 1:
			new_tiles.append(key)
	possible_tiles = new_tiles
	entropy = len(possible_tiles)
	collapse()
