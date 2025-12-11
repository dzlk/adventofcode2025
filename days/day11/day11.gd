extends BaseDay

func _init() -> void:
	super()

	day = 11
	title = "Day 11: Reactor"
	
	file = "input.txt"


func solve_part_one(input: String) -> Variant:
	var map = input_to_map(input)
	
	return calc_paths(map, "you", "out", "", {})


func solve_part_two(input: String) -> Variant:
	var map = input_to_map(input)
	
	var svr_dac = calc_paths(map, "svr", "dac", "fft", {})
	var svr_fft = calc_paths(map, "svr", "fft", "dac", {})
	var dac_fft = calc_paths(map, "dac", "fft", "", {})
	var fft_dac = calc_paths(map, "fft", "dac", "", {})
	var dac_out = calc_paths(map, "dac", "out", "", {})
	var fft_out = calc_paths(map, "fft", "out", "", {})
	
	return svr_dac * dac_fft * fft_out + svr_fft * fft_dac * dac_out
	
func calc_paths(map: Dictionary, from: String, to: String, avoid: String, memo: Dictionary = {}) -> int:
	if from == to:
		return 1
	if from == avoid:
		return 0
	if from not in map:
		return 0

	if from in memo:
		return memo[from]
	
	var res = 0
	for neighbor in map[from]:
		res += calc_paths(map, neighbor, to, avoid, memo)
	
	memo[from] = res
	return res
	
func input_to_map(input: String):
	var lines = input_to_lines(input)
	var map = {}
	
	for line in lines:
		var node = line.substr(0, line.find(":"))
		var nodes = line.split(" ").slice(1)
		
		map[node] = nodes

	return map
