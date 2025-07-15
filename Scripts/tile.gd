class_name Tile

var possible_tiles = [0,1,2,3,4]
var collapsed = false
var entropy = len(possible_tiles)
var current_tile = -1
var position: Vector2i

func collapse():
	if current_tile != -1:
		collapsed = true

func pick_random_possibility():
	var pick = possible_tiles.pick_random()
	#print("pos_tiles ", possible_tiles)
	#print("pick " ,pick)
	collapsed = true
	current_tile = pick
	return pick

func merge_possibilitys(pos: Array):
	#print("old ", possible_tiles)
	#print("merge ", pos)
	var dict := {
		0:0,
		1:0,
		2:0,
		3:0,
		4:0,
		5:0,
	}
	for a in pos:
		dict[a] += 1
	for a in possible_tiles:
		dict[a] += 1
	var new_tiles = []
	for key in dict.keys():
		if dict[key] > 1:
			new_tiles.append(key)
	possible_tiles = new_tiles
	#print("new ", possible_tiles)
	entropy = len(possible_tiles)
	collapse()
	#print(entropy)
	
	
	
