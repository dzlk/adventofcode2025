extends BaseDay

## Day 01: Calorie Counting (Example)
## This is a demo day showing how to use the framework with visualization

# Visualization panel (optional, add to scene if needed)
@onready var viz_panel: Panel = null  # Can add visualization panel to scene

func _init() -> void:
	day_number = 1
	day_title = "Calorie Counting (Example)"
	
	# Configure tests
	test_data = [
		{"file": "test_input.txt", "part1": 24000, "part2": 45000, "name": "Example 1"},
	]

func solve_part1(input: String) -> Variant:
	# Part 1: Find the Elf carrying the most Calories
	# Input: groups of numbers separated by blank lines
	# Output: the maximum sum of any group
	
	var lines = input.split("\n")
	var current_sum = 0
	var max_sum = 0
	
	for line in lines:
		var trimmed = line.strip_edges()
		
		if trimmed.is_empty():
			# Blank line means end of current elf's inventory
			max_sum = max(max_sum, current_sum)
			current_sum = 0
		else:
			# Add calories to current elf
			current_sum += int(trimmed)
	
	# Don't forget the last elf
	max_sum = max(max_sum, current_sum)
	
	return max_sum

func solve_part2(input: String) -> Variant:
	# Part 2: Find the top three Elves carrying the most Calories
	# Output: sum of the top three
	
	var lines = input.split("\n")
	var current_sum = 0
	var all_sums: Array[int] = []
	
	for line in lines:
		var trimmed = line.strip_edges()
		
		if trimmed.is_empty():
			if current_sum > 0:
				all_sums.append(current_sum)
			current_sum = 0
		else:
			current_sum += int(trimmed)
	
	# Don't forget the last elf
	if current_sum > 0:
		all_sums.append(current_sum)
	
	# Sort in descending order and take top 3
	all_sums.sort()
	all_sums.reverse()
	
	var top_three_sum = 0
	for i in range(min(3, all_sums.size())):
		top_three_sum += all_sums[i]
	
	return top_three_sum

## Helper function to parse elf groups (reusable)
func parse_elf_groups(input: String) -> Array[int]:
	var lines = input.split("\n")
	var current_sum = 0
	var all_sums: Array[int] = []
	
	for line in lines:
		var trimmed = line.strip_edges()
		
		if trimmed.is_empty():
			if current_sum > 0:
				all_sums.append(current_sum)
			current_sum = 0
		else:
			current_sum += int(trimmed)
	
	if current_sum > 0:
		all_sums.append(current_sum)
	
	return all_sums

## Optional visualization example
## To use: Add a Panel node named "VizPanel" to the scene
func visualize_results(sums: Array[int]) -> void:
	if viz_panel == null:
		return
	
	# This is where you could draw bars, charts, etc.
	# For now, just print the top values
	print("\nVisualization: Top 5 Elves by Calories:")
	var sorted_sums = sums.duplicate()
	sorted_sums.sort()
	sorted_sums.reverse()
	
	for i in range(min(5, sorted_sums.size())):
		print("  #%d: %s calories" % [i + 1, Globals.format_number(sorted_sums[i])])
