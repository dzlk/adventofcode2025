extends BaseDay

func _init():
	super()

	day = 7
	title = "Day 7: Laboratories"

	file = 'input.txt'
	
	logger.toggle_log_debug(false)
	
func solve_part_one(input: String) -> Variant:
	var lines = input_to_lines(input, false)
	
	var beams = {}
	var start = lines[0].find('S')
	var w = len(lines[0])
	logger.debug("start index = %s" % start)
	
	beams[start] = 1
	
	var res = 0
	for line in lines.slice(2):
		for b in beams.keys():
			if line[b] == '^':
				beams.erase(b)
				if b - 1 > -1:
					beams[b-1] = true
				if b + 1 < w:
					beams[b+1] = true
				
				res += 1
	
	return res
	
func solve_part_two(input: String) -> Variant:
	var lines = input_to_lines(input, false)
	
	var beams = {}
	var start = lines[0].find('S')
	var w = len(lines[0])
	logger.debug("start index = %s" % start)
	
	beams[start] = 1
	
	for line in lines.slice(2):
		for b in beams.keys():
			var v = beams[b]
			if line[b] == '^':
				beams.erase(b)
				if b - 1 > -1:
					if beams.has(b-1):
						beams[b-1] += v
					else:
						beams[b-1] = v
				if b + 1 < w:
					if beams.has(b+1):
						beams[b+1] += v
					else:
						beams[b+1] = v
				
		logger.debug(beams)
	
	var res = 0
	for v in beams.values():
		res += v
	
	return res
