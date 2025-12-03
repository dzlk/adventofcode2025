extends BaseDay

func _init() -> void:
	day = 3
	title = "Day 3: Lobby"
	
	file = "input.txt"
	
func solve_part_one(input: String) -> Variant:
	var lines = input_to_lines(input, false)
	
	var res = 0
	for line in lines:
		res += get_max(line, 2)
		update_part_one(res)
			
	return res

func solve_part_two(input: String) -> Variant:
	var lines = input_to_lines(input, false)
	
	var res = 0
	for line in lines:
		res += get_max(line, 12)
		update_part_two(res)
			
	return res
	
func get_max(line: String, l: int) -> int:
	var mx: Array = range(l)
		
	for i in range(1, len(line)):
		var next = line[i]
		for k in range(l):
			if i < mx[k]:
				break
			var curr = line[mx[k]]
			
			if next > curr && l - k < len(line) - i + 1:
				#var new_sub = line.substr(i, l - k)
				for n in range(0, l - k):
					mx[k + n] = i + n
				#print("change_max: ", to_int(line, mx), " (", k, ")")
				break
	
	
	var max_num = to_int(line, mx)
	#print("max_num: ", max_num)
	return max_num
	
func to_int(line: String, inds: Array) -> int:
	var num_str:String = ""
	
	for i in inds:
		num_str += line[i]
		
	return int(num_str)
