extends Node
class_name BaseDay

@onready var HUD = $HUD

var day: int = 0
var title: String = "Unknown"

var file: String

func _ready() -> void:
	HUD.set_title(title)
	
	# Run tests and then solve with real input
	await get_tree().process_frame  # Wait for UI to be ready
	
	run_solutions()

func solve_part_one(input: String) -> Variant:
	push_error("solve_part_one not implemented")
	return 0
	
func solve_part_two(input: String) -> Variant:
	push_error("solve_part_one not implemented")
	return 0
	
func input_to_lines(input: String, allow_empty: bool = true) -> PackedStringArray:
	return input.split("\n", allow_empty)
	
func run_solutions() -> void:
	var file_path = Globals.get_day_dir(day) + file
	var input = Globals.read_file(file_path)
	
	if input.is_empty():
		push_error("file not found. Place your puzzle input in: ", file_path)
		return
	
	print("\n" + "=".repeat(50))
	print("Solving")
	print("=".repeat(50))
	
	var result = solve_part_one(input)
	print("-> Part one Result: %s" % str(result))
	update_part_one(result)
	
	# Solve Part 2
	result = solve_part_two(input)
	print("-> Part 2 Result: %s" % str(result))
	update_part_two(result)
	
	print("=".repeat(50) + "\n")
	
func update_part_one(value: Variant):
	HUD.update_part_one(value)

func update_part_two(value: Variant):
	HUD.update_part_two(value)
