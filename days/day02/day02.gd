extends BaseDay

func _init() -> void:
	day = 2
	title = "Day 2: Gift Shop"

	file = "input.txt"

func solve_part_one(input: String) -> int:
	super()
	var res = 0
	
	var strs = input.split(',')
	var intervals = []
	
	for s in strs:
		var ints = s.split('-')
		intervals.append([ints[0], ints[1]])
		
	#print(intervals)
	
	for interval in intervals:
		#print(interval)
		var low = int(interval[0])
		var high = int(interval[1])
		
		
		var start = interval[0]
		var l = len(start)
		if len(start) % 2 == 1:
			start = str(int(pow(10, l + 1)))

		var num_part = int(start.substr(0, l / 2))
		
		while true:
			var num = int(str(num_part) + str(num_part))
			num_part += 1
			
			if num > high:
				break
				
			if num < low:
				continue
			
			#print("num: ", num)
			res += num

	return res
	
func solve_part_two(input: String) -> int:
	var strs = input.split(',')
	var intervals = []
	
	for s in strs:
		var ints = s.split('-')
		intervals.append([ints[0], ints[1]])
		
	var nums = {}
	for interval in intervals:
		var low = int(interval[0])
		var high = int(interval[1])
		
		var start = interval[0]
		var l = len(start)
		
		var parts = []
		var mults = [2, 3, 5, 7]
		# 28858486244
		# 28851819578
		
		for m in mults:
			var new_start = start
			if l % m > 0:
				new_start = str(int(pow(10, l + (m - l % m))))
			#print("old start: ", start)
			#print("new start: ", new_start)

			parts.append([m, int(new_start.substr(0, len(new_start) / m))]) 
			
		#print("parts: ", parts)
		
		
		while true:
			#break
			var done = 0
			
			# 2121 2121 18
			# 1000 0000 00000

			
			for i in parts.size():
				var m = parts[i][0]
				var part = parts[i][1]
				parts[i][1] += 1
				
				var num = int(str(part).repeat(m))
				#print(low, " ", high, " ", num)
				
				if num > high:
					done += 1
					continue
					
				if num < low:
					continue
					
				nums[num] = true
			
			print(done)
			if done == parts.size():
				break
	
	var res = 0
	for key in nums:
		res += key
		
	print("Nums: ", nums)
	
	print("Result: ", res)
	return res
