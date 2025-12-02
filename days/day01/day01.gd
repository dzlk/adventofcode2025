extends BaseDay

@export var dial: Sprite2D

var codes_count = 100
var start_code = 50

var epsilon = 0.01
	
func _init() -> void:
	day = 1
	title = "Day 1: Secret Entrance"
	
	file = "input.txt"
	
func solve_part_one(input: String) -> int:
	var res = 0;
	HUD.update_part_one(res)
	
	var current = start_code
	var codes = extract_codes(input)
	
	for code in codes:
		current = (current + code) % codes_count
		if current == 0:
			res += 1
			HUD.update_part_one(res)
	
	return res
	
func solve_part_two(input: String) -> int:
	var res = 0;
	HUD.update_part_two(res)
	
	var current = start_code
	var codes = extract_codes(input)
	
	print(codes.size())
	
	for code in codes:
		var prev = current
		var next = current + code
		var rest = (current + code) % codes_count
		current = rest if rest >= 0 else codes_count + rest
		print(prev, " + ", code, " -> ", current)
		
		if next > 0:
			print("+", abs(next) / codes_count, " ! ", next)
			res += abs(next) / codes_count
		elif  next < 0:
			print("+", (current + abs(code)) / codes_count, " !! ")
			res += (current + abs(code)) / codes_count
			if current == 0:
				res += 1
			if prev == 0:
				res -= 1
		else:
			res += 1
			print("+1")

		HUD.update_part_two(res)
		#await get_tree().create_timer(1).timeout
	
	return res
	
func extract_codes(input: String) -> Array[int]:
	var lines = input.split("\n", false)
	var codes: Array[int] = []
	
	for line in lines:
		codes.append(parse_code(line))
		
	return codes
	
func parse_code(code_txt: String) -> int:
	var dir = -1 if code_txt[0] == 'L' else 1
	var code = int(code_txt.substr(1))
	
	return dir * code
