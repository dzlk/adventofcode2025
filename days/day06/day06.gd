extends BaseDay

func _init() -> void:
	super()

	day = 6
	title = "Day 6: Trash Compactor"

	file = 'input.txt'

	logger.toggle_log_debug(false)


func solve_part_one(input: String) -> Variant:
	var lines = input_to_lines(input, false)

	var signs = lines[lines.size() - 1].split(' ', false)
	var count = len(signs)

	var sum = []

	for li in range(0, lines.size() - 1):
		var nums = Globals.extract_integers(lines[li])
		assert(nums.size() == count)

		if sum.size() == 0:
			sum = nums
			continue

		for i in range(count):
			if signs[i] == '+':
				sum[i] += nums[i]
				continue

			sum[i] *= nums[i]

	var res = 0
	for i in range(sum.size()):
		res += sum[i]

	return res


func solve_part_two(input: String) -> Variant:
	var lines = input_to_lines(input)
	var w = len(lines[0])
	var h = len(lines) - 1

	var res = 0
	var sign = ""
	var sub_res = 0
	for c in range(w):
		if sign == "":
			sign = lines[h - 1][c]
			logger.debug(sign)

		var num = ""
		for r in range(h - 1):
			var d = lines[r][c]
			logger.debug("d = %s" % d)
			if d == " ":
				continue
			num += d

		var value = int(num)

		logger.debug("%s -> %s" % [num, value])

		if value == 0:
			logger.debug("sub_res = %s" % sub_res)
			res += sub_res

			sign = ""
			sub_res = 0

		if sub_res == 0:
			sub_res = value
			continue

		sub_res = eval(sign, sub_res, value)

	res += sub_res

	return res


func eval(sign: String, lhs: int, rhs: int) -> int:
	return lhs + rhs if sign == '+' else lhs * rhs
