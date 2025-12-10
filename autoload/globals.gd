extends Node
## Global utilities for Advent of Code
## This script is autoloaded as a singleton

## Read file contents and return as string
func read_file(file_path: String) -> String:
	if not FileAccess.file_exists(file_path):
		push_error("File not found: " + file_path)
		return ""

	var file = FileAccess.open(file_path, FileAccess.READ)
	if file == null:
		push_error("Failed to open file: " + file_path)
		return ""

	var content = file.get_as_text()
	file.close()
	return content


## Format large numbers with thousand separators
func format_number(num: int) -> String:
	var num_str = str(num)
	var result = ""
	var count = 0

	for i in range(num_str.length() - 1, -1, -1):
		if count == 3:
			result = "," + result
			count = 0
		result = num_str[i] + result
		count += 1

	return result


## Parse a grid of characters from lines
func parse_grid(lines: PackedStringArray) -> Array:
	var grid = []
	for line in lines:
		var row = []
		for c in line:
			row.append(c)
		grid.append(row)
	return grid


## Parse integers from a string (extracts all numbers)
func extract_integers(text: String) -> Array[int]:
	var numbers: Array[int] = []
	var regex = RegEx.new()
	regex.compile("-?\\d+")

	for result in regex.search_all(text):
		numbers.append(int(result.get_string()))

	return numbers


## Get the directory of a day (e.g., "res://days/day01/")
func get_day_dir(day_num: int) -> String:
	return "res://days/day%02d/" % day_num


## Check if a day directory exists
func day_exists(day_num: int) -> bool:
	return DirAccess.dir_exists_absolute(get_day_dir(day_num))


