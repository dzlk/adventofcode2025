extends BaseDay

func _init() -> void:
	super()

	day = 5
	title = "Day 5: Cafeteria"
	
	file = "input.txt"
	
	logger.toggle_log_debug(false)
	
func solve_part_one(input: String) -> Variant:
	var res = 0
	var find_ids = false
	
	var ranges = []
	for line in input_to_lines(input):
		if line == "":
			find_ids = true
			logger.debug(str(ranges))
			continue
			
		if !find_ids:
			ranges.append(extract_range(line))
			continue
		
		var id = int(line)
		for r in ranges:
			if r[0] <= id && id <= r[1]:
				res += 1
				break
		
	return res
	
func solve_part_two(input: String) -> Variant:
	var ranges = []
	for line in input_to_lines(input):
		if line == "":
			break
		ranges.append(extract_range(line))
		
	ranges.sort_custom(func(a, b): return a[0] < b[0])
	logger.debug("ranges: %s" % [ranges])
	var res = 0
	var curr = ranges[0]
	for i in range(1, ranges.size()):
		var next = ranges[i]
		
		logger.debug("curr = %s; next = %s" % [curr, next])
		if curr[1] >= next[0]:
			var prev = curr
			curr[1] = max(curr[1], next[1])
			logger.debug("%s + %s -> %s" % [prev, next, curr])
			continue
			
		res += curr[1] - curr[0] + 1
		curr = next
		
	res += curr[1] - curr[0] + 1
	

	return res


func extract_range(line: String) -> Array[int]:
	var r = line.split("-")
	if r.size() != 2:
		logger.error("Not found range: %s" % line)
	
	return [int(r[0]), int(r[1])]
