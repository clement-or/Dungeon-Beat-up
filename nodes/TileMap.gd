extends TileMap

func _ready():
	pass
	
var min_x = 0
var min_y
var max_x
var max_y
func calculate_bounds():
	var used_cells = get_used_cells()
	for pos in used_cells:
		if pos.x < min_x:
			min_x = int(pos.x)
		elif pos.x > max_x:
			max_x = int(pos.x)
		if pos.y < min_y:
			min_y = int(pos.y)
		elif pos.y > max_y:
			max_y = int(pos.y)
