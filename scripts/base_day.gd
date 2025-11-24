extends Control
class_name BaseDay

## Base class for Advent of Code day solutions
## Automatically runs tests and then solves with real input

## UI References (set in scene)
@onready var title_label: Label = $MarginContainer/VBoxContainer/TitleLabel
@onready var test_container: VBoxContainer = $MarginContainer/VBoxContainer/TestResults/ScrollContainer/TestContainer
@onready var part1_label: Label = $MarginContainer/VBoxContainer/Results/Part1Result
@onready var part2_label: Label = $MarginContainer/VBoxContainer/Results/Part2Result
@onready var back_button: Button = $MarginContainer/VBoxContainer/BackButton

## Day information (override in child classes)
var day_number: int = 0
var day_title: String = "Unknown"

## Test configuration (override in child classes)
var test_data: Array[Dictionary] = []
# Example: [
#   {"file": "test_input.txt", "part1": 11, "part2": 31},
#   {"file": "test_input2.txt", "part1": 22, "part2": null}, # null if part2 not applicable
# ]

func _ready() -> void:
	if back_button:
		back_button.pressed.connect(_on_back_pressed)
	
	if title_label:
		title_label.text = "Day %d: %s" % [day_number, day_title]
	
	# Run tests and then solve with real input
	await get_tree().process_frame  # Wait for UI to be ready
	run_all_tests()
	solve_real_input()

## Override these methods in child classes
func solve_part1(input: String) -> Variant:
	push_error("solve_part1 not implemented")
	return null

func solve_part2(input: String) -> Variant:
	push_error("solve_part2 not implemented")
	return null

## Run all configured tests
func run_all_tests() -> void:
	if test_data.is_empty():
		add_test_result("No tests configured", Color.YELLOW)
		return
	
	print("\n" + "=".repeat(50))
	print("Running tests for Day %d: %s" % [day_number, day_title])
	print("=".repeat(50))
	
	var all_passed = true
	for i in range(test_data.size()):
		var test = test_data[i]
		var test_name = test.get("name", "Test %d" % (i + 1))
		
		# Run Part 1
		if test.has("part1") and test.part1 != null:
			var passed = run_test(test.file, test.part1, 1, test_name)
			if not passed:
				all_passed = false
		
		# Run Part 2
		if test.has("part2") and test.part2 != null:
			var passed = run_test(test.file, test.part2, 2, test_name)
			if not passed:
				all_passed = false
	
	print("=".repeat(50))
	if all_passed:
		print("✓ All tests passed!")
		add_test_result("✓ All tests passed!", Color.GREEN)
	else:
		print("✗ Some tests failed")
		add_test_result("✗ Some tests failed", Color.RED)
	print("=".repeat(50) + "\n")

## Run a single test
func run_test(filename: String, expected: Variant, part: int, test_name: String = "") -> bool:
	var file_path = get_day_dir() + filename
	var input = Globals.read_file(file_path)
	
	if input.is_empty():
		var msg = "%s Part %d: FILE NOT FOUND (%s)" % [test_name, part, filename]
		print("✗ " + msg)
		add_test_result("✗ " + msg, Color.RED)
		return false
	
	var result
	if part == 1:
		result = solve_part1(input)
	else:
		result = solve_part2(input)
	
	var passed = str(result) == str(expected)
	
	if passed:
		var msg = "%s Part %d: PASSED (expected: %s)" % [test_name, part, str(expected)]
		print("✓ " + msg)
		add_test_result("✓ " + msg, Color.GREEN)
	else:
		var msg = "%s Part %d: FAILED (expected: %s, got: %s)" % [test_name, part, str(expected), str(result)]
		print("✗ " + msg)
		add_test_result("✗ " + msg, Color.RED)
	
	return passed

## Solve with real input.txt
func solve_real_input() -> void:
	var file_path = get_day_dir() + "input.txt"
	var input = Globals.read_file(file_path)
	
	if input.is_empty():
		print("\n⚠ Warning: input.txt not found. Place your puzzle input in: " + file_path)
		update_result_label(part1_label, "Input file not found", Color.YELLOW)
		update_result_label(part2_label, "Input file not found", Color.YELLOW)
		return
	
	print("\n" + "=".repeat(50))
	print("Solving with real input.txt")
	print("=".repeat(50))
	
	# Solve Part 1
	var result1 = solve_part1(input)
	print("Part 1 Result: %s" % str(result1))
	update_result_label(part1_label, "Part 1: " + str(result1), Color.CYAN)
	
	# Solve Part 2
	var result2 = solve_part2(input)
	print("Part 2 Result: %s" % str(result2))
	update_result_label(part2_label, "Part 2: " + str(result2), Color.CYAN)
	
	print("=".repeat(50) + "\n")

## Helper: Get the directory for this day
func get_day_dir() -> String:
	return "res://days/day%02d/" % day_number

## Helper: Add a test result to the UI
func add_test_result(text: String, color: Color) -> void:
	if not test_container:
		return
	var label = Label.new()
	label.text = text
	label.add_theme_color_override("font_color", color)
	test_container.add_child(label)

## Helper: Update a result label
func update_result_label(label: Label, text: String, color: Color) -> void:
	if not label:
		return
	label.text = text
	label.add_theme_color_override("font_color", color)

## Back button handler
func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
