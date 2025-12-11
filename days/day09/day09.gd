extends BaseDay

func _init() -> void:
	super()
	day = 9
	title = "Day 9: Movie Theater"
	file = "input.txt"
	logger.toggle_log_debug(false)

func solve_part_one(input: String) -> Variant:
	var vectors = input_to_vector2i(input)
	
	var res = 0
	for i in range(vectors.size()):
		for j in range(i + 1, vectors.size()):
			var v1 = vectors[i]
			var v2 = vectors[j]
			var a = abs(v1.x - v2.x) + 1
			var b = abs(v1.y - v2.y) + 1
			var s = a * b
			res = max(res, s)
	
	return res

# NOTE: Писал Opus, моя идея и оптимизации
func solve_part_two(input: String) -> Variant:
	var red_tiles = input_to_vector2i(input)
	var regions = build_regions(red_tiles)
	
	logger.info("Total regions: %d" % regions.size())
	
	# Проверяем все пары красных точек
	var res = 0
	for i in range(red_tiles.size()):
		for j in range(i + 1, red_tiles.size()):
			var p1 = red_tiles[i]
			var p2 = red_tiles[j]
			
			if is_rectangle_valid(p1, p2, regions):
				var area = int((abs(p1.x - p2.x) + 1) * (abs(p1.y - p2.y) + 1))
				res = max(res, area)
	
	return res

# Строим регионы (объединённые интервалы) по вертикальным рёбрам полигона
# Возвращает массив регионов [{x1, x2, y1, y2}, ...] отсортированный по y1
func build_regions(red_tiles: PackedVector2Array) -> Array:
	# Собираем вертикальные рёбра полигона
	var vertical_edges: Array = []
	var n = red_tiles.size()
	
	for i in range(n):
		var p1 = red_tiles[i]
		var p2 = red_tiles[(i + 1) % n]
		
		if int(p1.x) == int(p2.x):  # вертикальное ребро
			var y_min = int(min(p1.y, p2.y))
			var y_max = int(max(p1.y, p2.y))
			vertical_edges.append({"x": int(p1.x), "y1": y_min, "y2": y_max})
	
	# Находим диапазон Y
	var min_y = int(red_tiles[0].y)
	var max_y = int(red_tiles[0].y)
	for tile in red_tiles:
		min_y = min(min_y, int(tile.y))
		max_y = max(max_y, int(tile.y))
	
	# Строим интервалы для каждого Y
	var intervals: Dictionary = {}
	for y in range(min_y, max_y + 1):
		var active_xs: Array = []
		for edge in vertical_edges:
			if edge.y1 <= y and y <= edge.y2:
				active_xs.append(edge.x)
		
		if active_xs.size() >= 2:
			intervals[y] = [active_xs.min(), active_xs.max()]
	
	# Объединяем последовательные строки с одинаковым интервалом в регионы
	var regions: Array = []
	var ys = intervals.keys()
	ys.sort()
	
	if ys.is_empty():
		return regions
	
	var curr_y1 = ys[0]
	var curr_x1 = intervals[ys[0]][0]
	var curr_x2 = intervals[ys[0]][1]
	
	for i in range(1, ys.size()):
		var y = ys[i]
		var x1 = intervals[y][0]
		var x2 = intervals[y][1]
		
		# Если строка непоследовательна или интервал изменился - сохраняем регион
		if y != ys[i - 1] + 1 or x1 != curr_x1 or x2 != curr_x2:
			regions.append({"x1": curr_x1, "x2": curr_x2, "y1": curr_y1, "y2": ys[i - 1]})
			curr_y1 = y
			curr_x1 = x1
			curr_x2 = x2
	
	# Последний регион
	regions.append({"x1": curr_x1, "x2": curr_x2, "y1": curr_y1, "y2": ys[ys.size() - 1]})
	
	return regions

# Проверяет, что весь прямоугольник помещается в регионы
func is_rectangle_valid(p1: Vector2, p2: Vector2, regions: Array) -> bool:
	var rect_x1 = int(min(p1.x, p2.x))
	var rect_x2 = int(max(p1.x, p2.x))
	var rect_y1 = int(min(p1.y, p2.y))
	var rect_y2 = int(max(p1.y, p2.y))
	
	var y = rect_y1
	for region in regions:
		# Пропускаем регионы выше прямоугольника
		if region.y2 < rect_y1:
			continue
		# Заканчиваем если регион ниже прямоугольника
		if region.y1 > rect_y2:
			break
		
		# Проверяем что X прямоугольника помещается в регион
		if rect_x1 < region.x1 or rect_x2 > region.x2:
			return false
		
		# Проверяем непрерывность покрытия по Y
		if region.y1 > y:
			return false  # Есть разрыв
		
		y = region.y2 + 1
	
	# Проверяем что покрыли весь прямоугольник
	return y > rect_y2
