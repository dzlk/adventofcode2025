# 🚀 Быстрый старт

## Первый запуск

1. **Откройте проект в Godot 4.5+**
   ```bash
   # Или просто откройте через Godot Project Manager
   godot --path . --editor
   ```

2. **Установите GUT addon (для юнит-тестов):**
   - В редакторе: AssetLib → Search "Gut" → Download
   - Или скачайте вручную с https://github.com/bitwes/Gut
   - Распакуйте в `addons/gut/`
   - Project Settings → Plugins → Enable "Gut"

3. **Запустите проект (F5)**
   - Увидите главное меню с Day 1
   - Нажмите "Day 1" чтобы запустить пример

## Что работает из коробки

✅ **Главное меню** - автоматически находит все дни
✅ **Day 01 (пример)** - полностью рабочий пример с тестами
✅ **Автоматические тесты** - запускаются при открытии дня
✅ **Globals utilities** - готовые функции для парсинга и работы с файлами
✅ **Template** - готовый шаблон для новых дней

## Создание своего первого дня

### Быстрый способ (копирование template):

```bash
# 1. Скопируйте template
cp -r days/day_template days/day02
cd days/day02

# 2. Переименуйте файлы
mv day_template.gd day02.gd
mv day_template.tscn day02.tscn

# 3. Откройте day02.tscn в текстовом редакторе и замените:
# [ext_resource ... path="res://days/day_template/day_template.gd" ...]
# на:
# [ext_resource ... path="res://days/day02/day02.gd" ...]
```

### Или через Godot:

1. В Godot откройте `days/day_template/day_template.tscn`
2. Scene → Save Scene As → `days/day02/day02.tscn`
3. Attach new script → сохраните как `day02.gd`

### Настройте день:

```gdscript
# В day02.gd:
func _init() -> void:
	day_number = 2
	day_title = "Название задачи с adventofcode.com"
	
	test_data = [
		{"file": "test_input.txt", "part1": 123, "part2": 456, "name": "Example"},
	]

func solve_part1(input: String) -> Variant:
	var lines = input.split("\n", false)
	# Ваше решение
	return 0
```

### Добавьте данные:

1. Скопируйте пример из задачи в `test_input.txt`
2. Скопируйте свой input в `input.txt`
3. Укажите ожидаемые результаты в `test_data`

### Запустите:

- F5 → Выберите Day 2 из меню
- Или откройте `day02.tscn` и нажмите F6

## Структура решения

### Минимальный пример:

```gdscript
extends BaseDay

func _init() -> void:
	day_number = 2
	day_title = "Rock Paper Scissors"
	test_data = [
		{"file": "test_input.txt", "part1": 15, "part2": 12, "name": "Example"},
	]

func solve_part1(input: String) -> Variant:
	var lines = input.split("\n", false)
	var score = 0
	
	for line in lines:
		# Ваша логика
		score += calculate_score(line)
	
	return score

func solve_part2(input: String) -> Variant:
	# Другая логика для part 2
	return 0

# Хелперы
func calculate_score(line: String) -> int:
	return 0
```

### С визуализацией:

```gdscript
extends BaseDay

@onready var canvas: Control = $MarginContainer/VBoxContainer/Canvas

func solve_part1(input: String) -> Variant:
	var grid = Globals.parse_grid(input.split("\n", false))
	
	for y in range(grid.size()):
		for x in range(grid[y].size()):
			process_cell(x, y, grid[y][x])
			
			# Визуализация с задержкой
			draw_grid(grid)
			await get_tree().create_timer(0.1).timeout
	
	return result

func draw_grid(grid: Array) -> void:
	if canvas:
		canvas.queue_redraw()
	# Или используйте TileMap, Sprites и т.д.
```

## Полезные утилиты

```gdscript
# Чтение файлов
var text = Globals.read_file("res://days/day02/input.txt")
var lines = Globals.read_lines("res://days/day02/input.txt")

# Парсинг
var nums = Globals.extract_integers("x=10, y=-20")  # [10, -20]
var grid = Globals.parse_grid(lines)  # 2D массив

# Форматирование
print(Globals.format_number(1234567))  # "1,234,567"

# Цветной вывод
Globals.print_success("Passed!")
Globals.print_error("Failed!")
Globals.print_info("Processing...")
```

## Юнит-тесты

Создайте `tests/test_day02.gd`:

```gdscript
extends GutTest

const Day02 = preload("res://days/day02/day02.gd")

func test_calculate_score():
	var day = Day02.new()
	var result = day.calculate_score("A X")
	assert_eq(result, 4, "A X should score 4")
```

Запустите через GUT panel в редакторе.

## Горячие клавиши

- `F5` - Запуск проекта (главное меню)
- `F6` - Запуск текущей сцены
- `Ctrl+S` - Сохранить
- `Ctrl+Shift+S` - Сохранить как
- `Ctrl+D` - Дублировать строку
- `Ctrl+/` - Закомментировать

## Частые проблемы

### "Day not found in menu"
- Убедитесь что папка называется `dayXX` (с нулём: day01, day02, day15)
- Проверьте что `day_number` в скрипте совпадает с номером папки

### "File not found: input.txt"
- Это нормально! Положите свой input в файл `input.txt`
- Или используйте только `test_input.txt` для проверки

### "Tests failed"
- Проверьте ожидаемые значения в `test_data`
- Посмотрите вывод в консоли (Output tab)
- Сравните "expected" vs "got"

### GUT не установлен
- Юнит-тесты опциональны
- Автоматические тесты работают и без GUT
- Установите GUT только если хотите тестировать отдельные функции

## Следующие шаги

1. ✅ Изучите пример Day 01
2. ✅ Создайте свой первый день
3. ✅ Решите Part 1 задачи
4. ✅ Решите Part 2 задачи
5. ✅ (Опционально) Добавьте визуализацию
6. ✅ Получите звёзды на adventofcode.com! ⭐⭐

---

**Полная документация:** [README.md](README.md)

**Удачи! 🎄**
