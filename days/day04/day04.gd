extends BaseDay

var dirs = [
	Vector2(-1, -1),
	Vector2(0, -1),
	Vector2(1, -1),
	Vector2(-1, 0),
	Vector2(1, 0),
	Vector2(-1, 1),
	Vector2(0, 1),
	Vector2(1, 1),
]

func _init() -> void:
	super()
	
	day = 4
	title = "Day 4: Printing Department"
	
	file = 'input.txt'
	
	logger.toggle_log_debug(false)
	
func solve_part_one(input: String) -> Variant:
	var grid = Globals.parse_grid(input_to_lines(input, false))
	
	return solve(grid, false)
	
func solve_part_two(input: String) -> Variant:
	var grid = Globals.parse_grid(input_to_lines(input, false))
	
	return solve(grid, true)
	
func solve(grid, extract_fast: bool) -> int:
	logger.info("running solving... (extract_fast=%s)" % extract_fast)
	
	var w = grid[0].size();
	var h = grid.size()

	logger.log_grid(grid)
	
	var res = 0
	
	while true:
		var prev_res = res
		for y in range(grid.size()):
			var line = grid[y]
			for x in range(line.size()):
				if grid[y][x] == ".":
					continue

				var v = Vector2(x, y)
				
				var count = 0
				for dir in dirs:
					var nv = v + dir
					if nv.x < 0 || nv.y < 0 || nv.x >= w || nv.y >= h:
						continue
					var value = get_value(grid, nv)
					
					if value == '@':
						count += 1
				
				#print(v, " ", count)
				
				if count < 4:
					res += 1
					
					if extract_fast:
						grid[y][x] = '.'
		
		if !extract_fast || prev_res == res:
			break
	
	logger.log_grid(grid)
	
	return res
	
func get_value(grid: Array, v: Vector2):
	return grid[int(v.y)][int(v.x)]
