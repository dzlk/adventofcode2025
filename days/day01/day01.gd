extends Node2D

##Day 1: Secret Entrance
## This is a demo day showing how to use the framework with visualization

@export var ui_title: Label
@export var ui_back_button: Button

@export var ui_part_one: Label
@export var ui_part_two: Label

@export var dial: Sprite2D

var day = 1
var title = "Day 1: Secret Entrance"

var file = "input.txt"

var speed = 200
var codes_count = 100
var start_code = 50

var epsilon = 0.01
	
func _ready() -> void:
	ui_title.text = title
	
	if ui_back_button:
		ui_back_button.pressed.connect(_on_back_pressed)
	
	solve_input()

func _on_back_pressed():
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
	
func solve_part_one(input: String) -> int:
	var res = 0;
	ui_part_one.text = str(res)
	
	var current = start_code
	var codes = extract_codes(input)
	
	for code in codes:
		current = (current + code) % codes_count
		if current == 0:
			res += 1
			ui_part_one.text = str(res)
	
	return res
	
func solve_part_two(input: String) -> int:
	var res = 0;
	ui_part_two.text = str(res)
	
	var current = start_code
	var codes = extract_codes(input)
	
	print(codes.size())
	
	for code in codes:
		var prev = current
		var next = current + code
		var rest = (current + code) % codes_count
		current = rest if rest >= 0 else codes_count + rest
		print(prev, " + ", code, " -> ", current)
		
		if next > 0:
			print("+", abs(next) / codes_count, " ! ", next)
			res += abs(next) / codes_count
		elif  next < 0:
			print("+", (current + abs(code)) / codes_count, " !! ")
			res += (current + abs(code)) / codes_count
			if current == 0:
				res += 1
			if prev == 0:
				res -= 1
		else:
			res += 1
			print("+1")

		ui_part_two.text = str(res)
		#await get_tree().create_timer(1).timeout
	
	return res
	
func extract_codes(input: String) -> Array[int]:
	var lines = input.split("\n", false)
	var codes: Array[int] = []
	
	for line in lines:
		codes.append(parse_code(line))
		
	return codes
	
func parse_code(code_txt: String) -> int:
	var dir = -1 if code_txt[0] == 'L' else 1
	var code = int(code_txt.substr(1))
	
	return dir * code

func solve_input() -> void:
	var file_path = Globals.get_day_dir(day) + file
	var input = Globals.read_file(file_path)
	
	if input.is_empty():
		print("\n⚠ Warning: file not found. Place your puzzle input in: " + file_path)
		update_result_label(ui_part_one, "Input file not found", Color.YELLOW)
		update_result_label(ui_part_two, "Input file not found", Color.YELLOW)
		return
	
	print("\n" + "=".repeat(50))
	print("Solving")
	print("=".repeat(50))
	
	# Solve Part 1
	var result1 = await solve_part_one(input)
	print("Part 1 Result: %s" % str(result1))
	update_result_label(ui_part_one, "Part 1: " + str(result1), Color.CYAN)
	
	# Solve Part 2
	var result2 = await solve_part_two(input)
	print("Part 2 Result: %s" % str(result2))
	update_result_label(ui_part_two, "Part 2: " + str(result2), Color.CYAN)
	
	print("=".repeat(50) + "\n")
	
## Helper: Update a result label
func update_result_label(label: Label, text: String, color: Color) -> void:
	if not label:
		return
	label.text = text
	label.add_theme_color_override("font_color", color)
