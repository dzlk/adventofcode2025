class_name BaseDay
extends Node

@onready var HUD = $HUD

var logger: Lggr

var day: int = 0
var title: String = "Unknown"

var file: String


func _init() -> void:
	logger = Lggr.new()


func _ready() -> void:
	HUD.set_title(title)

	# Run tests and then solve with real input
	await get_tree().process_frame # Wait for UI to be ready

	run_solutions()

func solve_part_one(input: String) -> Variant:
	logger.error("solve_part_one not implemented")
	logger.debug(input)
	return 0


func solve_part_two(input: String) -> Variant:
	logger.error("solve_part_one not implemented")
	logger.debug(input)
	return 0


func input_to_lines(input: String, allow_empty: bool = true) -> PackedStringArray:
	return input.split("\n", allow_empty)


func input_to_vector2i(input: String) -> PackedVector2Array:
	var lines = input_to_lines(input, false)
	var vectors = PackedVector2Array()

	for line in lines:
		var c = Globals.extract_integers(line)
		assert(c.size() == 2)

		vectors.append(Vector2i(c[0], c[1]))

	return vectors


func run_solutions() -> void:
	var file_path = Globals.get_day_dir(day) + file
	var input = Globals.read_file(file_path)

	if input.is_empty():
		logger.error("file not found. Place your puzzle input in: %s" % file_path)
		return

	logger.info("Solving...")
	logger.log_delim(logger.Level.INFO, "=", 50)

	var result = await solve_part_one(input)
	logger.clog("ℹ️Part one result: %s" % str(result), Color.AQUAMARINE)
	update_part_one(result)

	# Solve Part 2
	result = await solve_part_two(input)
	logger.clog("ℹ️Part two result: %s" % str(result), Color.AQUAMARINE)
	update_part_two(result)

	logger.log_delim(logger.Level.INFO, "=", 50)


func update_part_one(value: Variant):
	HUD.update_part_one(value)


func update_part_two(value: Variant):
	HUD.update_part_two(value)
