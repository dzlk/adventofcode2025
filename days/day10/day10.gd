extends BaseDay

func _init() -> void:
	super()
	day = 10
	title = "Day 10: Factory"
	file = "input.txt"

	logger.toggle_log_debug(false)


func solve_part_one(input: String) -> Variant:
	var lines = input_to_lines(input, false)

	var res = 0
	for line in lines:
		var data = parse_line(line)
		logger.debug("%s => %s %s" % [line, String.num_int64(data[0], 2), get_masks(data[1])])

		var queue = [[0, 0]]
		var visited = { 0: true }

		while not queue.is_empty():
			var state = queue.pop_front()

			if state[0] == data[0]:
				res += state[1]
				logger.debug("steps = %s" % state[1])
				break

			for b in data[1]:
				var new_state = state[0] ^ b
				if not visited.has(new_state):
					visited[new_state] = true
					queue.push_back([new_state, state[1] + 1])

	return res


func solve_part_two(input: String) -> Variant:
	return solve_with_python()


func solve_with_python() -> int:
	var output = []
	var script_path = "res://days/day10/solver.py"
	var abs_path = ProjectSettings.globalize_path(script_path)

	# Используем Python из venv, где установлены numpy и scipy
	var python_path = ProjectSettings.globalize_path("res://days/day10/.venv/bin/python3")

	# Передаём абсолютный путь к input файлу
	var input_path = ProjectSettings.globalize_path(Globals.get_day_dir(day) + file)
	var exit_code = OS.execute(python_path, [abs_path, "--file", input_path], output, true)

	if exit_code != 0 or output.is_empty() or output[0].strip_edges() == "":
		logger.error("Python solver failed (exit=%d): %s" % [exit_code, str(output)])
		return 0

	return int(output[0].strip_edges())


func get_masks(nums: Array):
	var masks = []
	for n in nums:
		masks.append(String.num_int64(n, 2))
	return masks


func parse_line(line: String) -> Array:
	var parts = line.split(" ", false)

	var state = 0
	for i in range(1, len(parts[0]) - 1):
		if parts[0][i] == '#':
			var bit_pos = (i - 1)
			state |= (1 << bit_pos)

	var buttons = []
	for b in range(1, parts.size() - 1):
		var nums = Globals.extract_integers(parts[b])
		var mask = 0
		for n in nums:
			mask |= (1 << n)

		buttons.append(mask)

	return [state, buttons]


func parse_line2(line: String):
	var parts = line.split(" ", false)

	var state = Globals.extract_integers(parts[parts.size() - 1])
	var counters = []
	for c in range(1, parts.size() - 1):
		counters.append(Globals.extract_integers(parts[c]))

	return [state, counters]
