# 📋 Шпаргалка Advent of Code 2025

## Создание нового дня (копипаста)

```bash
# Замените XX на номер дня (например, 05, 15)
DAY=XX
cp -r days/day_template days/day$DAY
cd days/day$DAY
mv day_template.gd day$DAY.gd
mv day_template.tscn day$DAY.tscn

# Откройте day$DAY.tscn и замените путь к скрипту:
# res://days/day_template/day_template.gd → res://days/day$DAY/day$DAY.gd
```

## Шаблон скрипта дня

```gdscript
extends BaseDay

func _init() -> void:
	day_number = 1  # ИЗМЕНИТЬ
	day_title = "Day Title"  # ИЗМЕНИТЬ
	
	test_data = [
		{"file": "test_input.txt", "part1": null, "part2": null, "name": "Example"},
	]

func solve_part1(input: String) -> Variant:
	var lines = input.split("\n", false)
	# TODO: Решение
	return 0

func solve_part2(input: String) -> Variant:
	var lines = input.split("\n", false)
	# TODO: Решение
	return 0
```

## Полезные сниппеты

### Парсинг входных данных

```gdscript
# Разбить на строки (без пустых)
var lines = input.split("\n", false)

# Разбить на строки (с пустыми)
var lines = input.split("\n")

# Получить числа из строки
var numbers = Globals.extract_integers("x=10 y=-5")  # [10, -5]

# Парсинг сетки символов
var grid = Globals.parse_grid(lines)  # [[char, char], [char, char], ...]

# Чтение пар/групп разделённых пустой строкой
var groups = input.split("\n\n")
for group in groups:
	var items = group.split("\n")
```

### Работа с сетками

```gdscript
# Создание пустой сетки
var grid = []
for y in range(height):
	var row = []
	for x in range(width):
		row.append(".")
	grid.append(row)

# Обход сетки
for y in range(grid.size()):
	for x in range(grid[y].size()):
		var cell = grid[y][x]

# Проверка границ
func in_bounds(x: int, y: int, grid: Array) -> bool:
	return y >= 0 and y < grid.size() and x >= 0 and x < grid[y].size()

# Соседи (4 направления)
const DIRS = [Vector2i(0, -1), Vector2i(1, 0), Vector2i(0, 1), Vector2i(-1, 0)]
for dir in DIRS:
	var nx = x + dir.x
	var ny = y + dir.y
	if in_bounds(nx, ny, grid):
		var neighbor = grid[ny][nx]

# Соседи (8 направлений)
const DIRS8 = [
	Vector2i(-1, -1), Vector2i(0, -1), Vector2i(1, -1),
	Vector2i(-1,  0),                  Vector2i(1,  0),
	Vector2i(-1,  1), Vector2i(0,  1), Vector2i(1,  1),
]
```

### Алгоритмы поиска

```gdscript
# BFS (поиск в ширину)
func bfs(start: Vector2i, grid: Array) -> Dictionary:
	var queue = [start]
	var visited = {start: true}
	var distances = {start: 0}
	
	while queue.size() > 0:
		var pos = queue.pop_front()
		var dist = distances[pos]
		
		for dir in DIRS:
			var next = pos + dir
			if in_bounds(next.x, next.y, grid) and not visited.has(next):
				if grid[next.y][next.x] != "#":  # проходимо
					visited[next] = true
					distances[next] = dist + 1
					queue.append(next)
	
	return distances

# DFS (поиск в глубину)
func dfs(pos: Vector2i, grid: Array, visited: Dictionary) -> void:
	if visited.has(pos):
		return
	
	visited[pos] = true
	
	for dir in DIRS:
		var next = pos + dir
		if in_bounds(next.x, next.y, grid) and grid[next.y][next.x] != "#":
			dfs(next, grid, visited)

# Dijkstra (кратчайший путь с весами)
func dijkstra(start: Vector2i, grid: Array) -> Dictionary:
	var distances = {start: 0}
	var pq = [[0, start]]  # [distance, position]
	
	while pq.size() > 0:
		pq.sort_custom(func(a, b): return a[0] < b[0])
		var current = pq.pop_front()
		var dist = current[0]
		var pos = current[1]
		
		if dist > distances.get(pos, INF):
			continue
		
		for dir in DIRS:
			var next = pos + dir
			if in_bounds(next.x, next.y, grid):
				var weight = 1  # или другой вес
				var new_dist = dist + weight
				
				if new_dist < distances.get(next, INF):
					distances[next] = new_dist
					pq.append([new_dist, next])
	
	return distances
```

### Работа с числами

```gdscript
# GCD (наибольший общий делитель)
func gcd(a: int, b: int) -> int:
	while b != 0:
		var temp = b
		b = a % b
		a = temp
	return a

# LCM (наименьшее общее кратное)
func lcm(a: int, b: int) -> int:
	return abs(a * b) / gcd(a, b)

# Проверка на простое число
func is_prime(n: int) -> bool:
	if n < 2:
		return false
	for i in range(2, int(sqrt(n)) + 1):
		if n % i == 0:
			return false
	return true

# Факториал
func factorial(n: int) -> int:
	var result = 1
	for i in range(2, n + 1):
		result *= i
	return result
```

### Работа со словарями и множествами

```gdscript
# Подсчёт вхождений
var counts = {}
for item in array:
	counts[item] = counts.get(item, 0) + 1

# Множество (используем Dictionary)
var visited = {}
visited[pos] = true
if visited.has(pos):
	print("Already visited")

# Сортировка словаря по значениям
var items = counts.keys()
items.sort_custom(func(a, b): return counts[a] > counts[b])
```

### Регулярные выражения

```gdscript
# Извлечение чисел
var regex = RegEx.new()
regex.compile("-?\\d+")
for match in regex.search_all(text):
	var num = int(match.get_string())

# Поиск паттерна
var regex = RegEx.new()
regex.compile("move (\\d+) from (\\d+) to (\\d+)")
var result = regex.search(line)
if result:
	var count = int(result.get_string(1))
	var from = int(result.get_string(2))
	var to = int(result.get_string(3))
```

### Визуализация

```gdscript
# Добавьте в сцену Control или Panel для рисования
@onready var canvas: Control = $VizPanel

# Отрисовка с задержкой
func visualize_step(state):
	draw_state(state)
	await get_tree().create_timer(0.05).timeout

# Кастомная отрисовка
func _draw():
	# Прямоугольник
	draw_rect(Rect2(x, y, width, height), Color.RED)
	
	# Линия
	draw_line(Vector2(x1, y1), Vector2(x2, y2), Color.BLUE, 2.0)
	
	# Круг
	draw_circle(Vector2(x, y), radius, Color.GREEN)
	
	# Текст
	draw_string(font, Vector2(x, y), "Text", HORIZONTAL_ALIGNMENT_LEFT, -1, 16, Color.WHITE)

# Триггер перерисовки
func update_visualization():
	canvas.queue_redraw()
```

## Globals утилиты

```gdscript
# Файлы
Globals.read_file(path)              # → String
Globals.read_lines(path)             # → PackedStringArray

# Парсинг
Globals.extract_integers(text)       # → Array[int]
Globals.parse_grid(lines)            # → Array (2D)

# Форматирование
Globals.format_number(1234567)       # → "1,234,567"

# Логирование (цветное в консоли)
Globals.print_success("✓ Passed")
Globals.print_error("✗ Failed")
Globals.print_info("ℹ Info")

# Утилиты дней
Globals.get_day_dir(5)               # → "res://days/day05/"
Globals.day_exists(5)                # → bool
```

## Отладка

```gdscript
# Принты
print("Value:", value)
print_debug("Debug info")  # с line number
printerr("Error!")         # в stderr

# Брейкпоинты
breakpoint  # остановка выполнения

# Ассерты
assert(value > 0, "Value must be positive")

# Замер времени
var start = Time.get_ticks_msec()
# ... код ...
var elapsed = Time.get_ticks_msec() - start
print("Elapsed: %d ms" % elapsed)
```

## Частые паттерны AoC

### Day с несколькими тестовыми входами

```gdscript
test_data = [
	{"file": "test1.txt", "part1": 10, "part2": 20, "name": "Example 1"},
	{"file": "test2.txt", "part1": 15, "part2": 25, "name": "Example 2"},
]
```

### Разные ожидания для part1 и part2

```gdscript
test_data = [
	{"file": "test_input.txt", "part1": 11, "part2": null, "name": "Part 1 only"},
]
```

### Переиспользование кода между частями

```gdscript
func solve_part1(input: String) -> Variant:
	return solve(input, false)

func solve_part2(input: String) -> Variant:
	return solve(input, true)

func solve(input: String, is_part2: bool) -> Variant:
	# Общая логика с условиями
	if is_part2:
		# ...
	return result
```

## Горячие клавиши Godot

- `F5` - Запуск проекта
- `F6` - Запуск текущей сцены
- `F7` - Пауза
- `F8` - Step over (при отладке)
- `Ctrl+D` - Дублировать
- `Ctrl+/` - Комментарий
- `Ctrl+F` - Поиск
- `Ctrl+Shift+F` - Поиск в файлах
- `Ctrl+Space` - Автодополнение

---

**Больше информации:** [README.md](README.md) | [QUICKSTART.md](QUICKSTART.md)
