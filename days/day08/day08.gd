extends BaseDay

var steps = {
	"test_input.txt": 10,
	"input.txt": 1000,
}

var step = 0


func _init() -> void:
	super()

	day = 8
	title = "Day 8: Playground"

	file = "input.txt"
	step = steps[file]


func solve_part_one(input: String) -> Variant:
	var boxes = parse_boxes(input)
	var distances = calc_distances(boxes)

	var c = 0
	var b2c = { }
	var c2b = { }

	for k in range(0, step):
		var edge = distances[k]
		var ac = b2c.get(edge.a)
		var bc = b2c.get(edge.b)

		if ac == null && bc == null:
			b2c[edge.a] = c
			b2c[edge.b] = c

			c2b[c] = [edge.a, edge.b]

			c += 1
			continue

		if ac == null:
			b2c[edge.a] = bc
			c2b[bc].append(edge.a)
			continue

		if bc == null:
			b2c[edge.b] = ac
			c2b[ac].append(edge.b)
			continue

		if ac == bc:
			continue

		c2b[ac].append_array(c2b[bc])
		for b in c2b[bc]:
			b2c[b] = ac
		c2b.erase(bc)

	var sizes = []
	for v in c2b.values():
		sizes.append(v.size())
	sizes.sort()

	var res = 1
	var l = 0
	for s in range(3):
		res *= sizes[l - s - 1]

	return res


func solve_part_two(input: String) -> Variant:
	var boxes = parse_boxes(input)
	var distances = calc_distances(boxes)

	var c = 0
	var b2c = { }
	var c2b = { }

	var found = -1

	for k in range(0, distances.size()):
		var edge = distances[k]
		var ac = b2c.get(edge.a)
		var bc = b2c.get(edge.b)

		if ac == null && bc == null:
			b2c[edge.a] = c
			b2c[edge.b] = c
			c2b[c] = [edge.a, edge.b]
			c += 1
		elif ac == null:
			b2c[edge.a] = bc
			c2b[bc].append(edge.a)
		elif bc == null:
			b2c[edge.b] = ac
			c2b[ac].append(edge.b)
		elif ac != bc:
			c2b[ac].append_array(c2b[bc])
			for b in c2b[bc]:
				b2c[b] = ac
			c2b.erase(bc)

		if c2b.size() == 1 && b2c.size() == boxes.size():
			found = k
			break

	assert(found > -1, "should found last edge")
	var a = boxes[distances[found].a]
	var b = boxes[distances[found].b]
	logger.debug("a=%s, b=%s" % [a, b])

	return int(a.x * b.x)


func parse_boxes(input: String) -> Array:
	var boxes = []

	for line in input_to_lines(input, false):
		var coords = Globals.extract_integers(line)
		assert(coords.size() == 3, "should parse three coords")

		boxes.append(Vector3(float(coords[0]), float(coords[1]), float(coords[2])))

	return boxes


func calc_distances(boxes: Array) -> Array:
	var distances = []
	for i in range(boxes.size()):
		for j in range(i + 1, boxes.size()):
			distances.append(
				{
					"a": i,
					"b": j,
					"d": boxes[i].distance_to(boxes[j]),
				},
			)

	distances.sort_custom(func(dl, dr): return dl.d < dr.d)
	return distances
