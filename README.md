# Advent of Code 2025 - Godot Edition

Решения задач [Advent of Code 2025](https://adventofcode.com/2025) на GDScript с использованием движка Godot 4.5.

## 🏗️ Структура проекта

```
advent-of-code-2025/
├── days/                    # Решения дней
│   ├── day01/              # День 1 (пример)
│   │   ├── day01.tscn      # Сцена дня
│   │   ├── day01.gd        # Логика решения
│   │   ├── test_input.txt  # Тестовый input
│   │   └── input.txt       # Личный input (не коммитится)
│   └── ...
├── scripts/                 # Общие скрипты
│   └── base_day.gd         # Базовый класс для дней
├── scenes/                  # Общие сцены
│   ├── main_menu.tscn      # Главное меню
│   └── main_menu.gd
├── autoload/                # Автозагрузка (singletons)
│   └── globals.gd          # Глобальные утилиты
├── tests/                   # Юнит-тесты (GUT)
│   ├── test_day01.gd
│   └── test_globals.gd
└── addons/                  # Аддоны
	└── gut/                # GUT testing framework
```

## 🚀 Быстрый старт

### Требования

- Godot 4.5 или выше
- GUT addon (для юнит-тестов)

### Установка

1. Клонируйте репозиторий:
```bash
git clone https://github.com/dzlk/advent-of-code-2025.git
cd advent-of-code-2025
```

2. Откройте проект в Godot

3. Установите GUT addon:
   - Откройте AssetLib в редакторе Godot
   - Найдите "Gut" (Godot Unit Test)
   - Скачайте и установите в папку `addons/gut/`
   - Включите плагин в Project Settings → Plugins

### Запуск

**Через главное меню:**
- Запустите проект (F5)
- Выберите день из списка
- Тесты запустятся автоматически, затем решение

**Прямой запуск дня:**
- Откройте сцену дня (например, `days/day01/day01.tscn`)
- Запустите сцену (F6)

**Запуск юнит-тестов:**
- Откройте панель GUT в редакторе
- Нажмите "Run All"
- Или запустите через командную строку: `godot --path . -s addons/gut/gut_cmdln.gd`

### Способ 2: Через Godot Editor

1. Создайте новую папку `days/dayXX/`
2. Создайте новую сцену, наследующую `BaseDay`
3. Добавьте HUD
4. Создайте скрипт, расширяющий `BaseDay`

## 🎨 Добавление визуализации

Для задач требующих визуализацию (например, движение робота по сетке):

1. Добавьте узлы визуализации в сцену:
```
Day01
├── MarginContainer
│   └── VBoxContainer
│       ├── ... (стандартные элементы)
│       └── VisualizationPanel
│           └── GridContainer/TileMap/Control
```

2. Получите ссылку в скрипте:
```gdscript
@onready var viz_panel: Panel = $MarginContainer/VBoxContainer/VisualizationPanel
```

3. Создайте методы визуализации:
```gdscript
func visualize_step(state: Dictionary) -> void:
	# Отрисовка текущего состояния
	queue_redraw()
	await get_tree().create_timer(0.1).timeout  # Задержка для анимации

func _draw() -> void:
	# Кастомная отрисовка через CanvasItem
	draw_rect(Rect2(0, 0, 100, 100), Color.RED)
```

4. Опционально добавьте кнопку "Step" для пошагового выполнения

## 🧪 Тестирование

### Автоматические тесты (встроенные)

Каждый день автоматически запускает тесты при открытии:

```gdscript
test_data = [
	{"file": "test_input.txt", "part1": 11, "part2": 31, "name": "Example 1"},
	{"file": "test_input2.txt", "part1": 22, "part2": null, "name": "Example 2"},
]
```

Результаты выводятся в консоль и UI:
```
✓ Example 1 Part 1: PASSED (expected: 11)
✗ Example 1 Part 2: FAILED (expected: 31, got: 25)
```

### Юнит-тесты (GUT)

Для тестирования отдельных функций создайте файл в `tests/`:

```gdscript
extends GutTest

const Day01 = preload("res://days/day01/day01.gd")

func test_helper_function():
	var day = Day01.new()
	var result = day.parse_data("test")
	assert_eq(result, expected_value, "Should parse correctly")
```

Запустите через GUT panel или командную строку.

## 🛠️ Полезные утилиты (Globals)

Глобальные функции доступны везде через `Globals`:

```gdscript
# Чтение файлов
var content = Globals.read_file("res://days/day01/input.txt")
var lines = Globals.read_lines("res://days/day01/input.txt")

# Парсинг
var numbers = Globals.extract_integers("x=10, y=-5")  # [10, -5]
var grid = Globals.parse_grid(lines)  # 2D массив символов

# Форматирование
var formatted = Globals.format_number(1234567)  # "1,234,567"

# Логирование (цветное)
Globals.print_success("Test passed!")
Globals.print_error("Test failed!")
Globals.print_info("Running tests...")

# Проверка дней
if Globals.day_exists(5):
	print("Day 5 exists")
```

## 📊 Примеры использования

### Простая задача (только вычисления)

```gdscript
func solve_part1(input: String) -> Variant:
	var lines = Globals.read_lines_from_string(input)
	var total = 0
	
	for line in lines:
		var numbers = Globals.extract_integers(line)
		total += numbers[0]
	
	return total
```

### Задача с визуализацией

```gdscript
func solve_part1(input: String) -> Variant:
	var grid = Globals.parse_grid(Globals.read_lines_from_string(input))
	
	for y in range(grid.size()):
		for x in range(grid[y].size()):
			# Обработка
			visualize_cell(x, y, grid[y][x])
			await get_tree().create_timer(0.05).timeout
	
	return result

func visualize_cell(x: int, y: int, value: String) -> void:
	# Рисуем клетку
	queue_redraw()
```

## 📚 Ресурсы

- [Advent of Code 2025](https://adventofcode.com/2025)
- [Godot Documentation](https://docs.godotengine.org/)
- [GDScript Style Guide](https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_styleguide.html)
- [GUT Testing Framework](https://github.com/bitwes/Gut)

## 🎮 Горячие клавиши

- `F5` - Запустить проект (главное меню)
- `F6` - Запустить текущую сцену
- `Ctrl+D` - Дублировать узел/строку
- `Ctrl+Shift+C` - Закомментировать код

## 📋 Чеклист для каждого дня

- [ ] Скопировать template в `days/dayXX/`
- [ ] Переименовать файлы и обновить пути
- [ ] Установить `day_number` и `day_title`
- [ ] Добавить тестовые данные в `test_input.txt`
- [ ] Настроить `test_data` с ожидаемыми результатами
- [ ] Реализовать `solve_part1()`
- [ ] Проверить тесты Part 1
- [ ] Получить звезду ⭐ за Part 1
- [ ] Реализовать `solve_part2()`
- [ ] Проверить тесты Part 2
- [ ] Получить звезду ⭐ за Part 2
- [ ] (Опционально) Добавить визуализацию
- [ ] (Опционально) Написать юнит-тесты для хелперов
