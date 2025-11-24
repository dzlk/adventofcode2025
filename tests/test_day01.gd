extends GutTest

## Unit tests for Day 01 helper functions
## These tests run independently of the main solution
## They test individual functions in isolation

# Note: To run these tests, you need to have GUT addon installed
# Install GUT from: https://github.com/bitwes/Gut
# Or through Godot Asset Library

# Preload the day01 script to test its functions
const Day01 = preload("res://days/day01/day01.gd")

func before_each():
	gut.p("Running test...")

func after_each():
	gut.p("Test completed")

## Test the parse_elf_groups helper function
func test_parse_elf_groups_single_elf():
	var day = Day01.new()
	var input = "1000\n2000\n3000"
	var result = day.parse_elf_groups(input)
	
	assert_eq(result.size(), 1, "Should have 1 elf")
	assert_eq(result[0], 6000, "Elf should carry 6000 calories")

func test_parse_elf_groups_multiple_elves():
	var day = Day01.new()
	var input = "1000\n2000\n\n3000\n4000"
	var result = day.parse_elf_groups(input)
	
	assert_eq(result.size(), 2, "Should have 2 elves")
	assert_eq(result[0], 3000, "First elf should carry 3000 calories")
	assert_eq(result[1], 7000, "Second elf should carry 7000 calories")

func test_parse_elf_groups_empty_input():
	var day = Day01.new()
	var input = ""
	var result = day.parse_elf_groups(input)
	
	assert_eq(result.size(), 0, "Should have no elves")

func test_parse_elf_groups_trailing_newline():
	var day = Day01.new()
	var input = "1000\n\n2000\n"
	var result = day.parse_elf_groups(input)
	
	assert_eq(result.size(), 2, "Should have 2 elves")
	assert_eq(result[0], 1000, "First elf should carry 1000 calories")
	assert_eq(result[1], 2000, "Second elf should carry 2000 calories")

## Test Part 1 solution with known input
func test_solve_part1_example():
	var day = Day01.new()
	day.day_number = 1
	day.day_title = "Test"
	
	var input = "1000\n2000\n3000\n\n4000\n\n5000\n6000\n\n7000\n8000\n9000\n\n10000"
	var result = day.solve_part1(input)
	
	assert_eq(result, 24000, "Part 1 should return 24000")

## Test Part 2 solution with known input
func test_solve_part2_example():
	var day = Day01.new()
	day.day_number = 1
	day.day_title = "Test"
	
	var input = "1000\n2000\n3000\n\n4000\n\n5000\n6000\n\n7000\n8000\n9000\n\n10000"
	var result = day.solve_part2(input)
	
	assert_eq(result, 45000, "Part 2 should return 45000 (sum of top 3: 24000 + 11000 + 10000)")
