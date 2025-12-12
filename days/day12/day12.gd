extends BaseDay

func _init() -> void:
	super()
	day = 12
	title = "Day 12: Christmas Tree Farm"
	
	file = 'input.txt'
	
func solve_part_one(input: String) -> Variant:
	var res = 0
	
	var lines = input_to_lines(input)
	
	var count = 0
	var sizes = []
	
	while count < 6:
		logger.debug(count)
		var start = count * 5
		logger.debug("start = " + str(start))
		var size = 0
		for line in lines.slice(start + 1, start + 4):
			for c in line:
				if c == '#':
					size += 1
			
			logger.debug(line)
		sizes.append(size)
		logger.debug("size = %s" % size)
		
		count += 1
		logger.log_delim(logger.Level.DEBUG)

	
	for ln in range(count*5, lines.size() - 1):
		var nums = Globals.extract_integers(lines[ln])
		
		var grid_size = nums[0] * nums[1]
		var shape_size = 0
		for i in range(sizes.size()):
			shape_size += sizes[i] * nums[i + 2]
		
		if float(grid_size) / float(shape_size) > 1.3:
			res += 1
		elif grid_size < shape_size:
			pass
		else:
			logger.debug(nums)
			logger.debug("%s / %s = %s" % [grid_size, shape_size, float(grid_size) / float(shape_size)])
			logger.log_delim(logger.Level.DEBUG)
	
	return res

func solve_part_two(input: String) -> Variant:
	return 0
