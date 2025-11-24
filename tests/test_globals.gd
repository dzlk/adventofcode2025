extends GutTest

## Unit tests for Globals utilities
## Testing the global helper functions

func test_format_number_small():
	var result = Globals.format_number(123)
	assert_eq(result, "123", "Small numbers should not have commas")

func test_format_number_thousands():
	var result = Globals.format_number(1234)
	assert_eq(result, "1,234", "Should add comma for thousands")

func test_format_number_millions():
	var result = Globals.format_number(1234567)
	assert_eq(result, "1,234,567", "Should add commas for millions")

func test_format_number_zero():
	var result = Globals.format_number(0)
	assert_eq(result, "0", "Zero should be formatted as 0")

func test_extract_integers_positive():
	var result = Globals.extract_integers("The answer is 42")
	assert_eq(result.size(), 1, "Should find 1 number")
	assert_eq(result[0], 42, "Should extract 42")

func test_extract_integers_negative():
	var result = Globals.extract_integers("Temperature is -10 degrees")
	assert_eq(result.size(), 1, "Should find 1 number")
	assert_eq(result[0], -10, "Should extract -10")

func test_extract_integers_multiple():
	var result = Globals.extract_integers("Position: x=10, y=-5, z=100")
	assert_eq(result.size(), 3, "Should find 3 numbers")
	assert_eq(result[0], 10, "Should extract 10")
	assert_eq(result[1], -5, "Should extract -5")
	assert_eq(result[2], 100, "Should extract 100")

func test_extract_integers_none():
	var result = Globals.extract_integers("No numbers here")
	assert_eq(result.size(), 0, "Should find no numbers")

func test_parse_grid_simple():
	var lines = PackedStringArray(["ABC", "DEF", "GHI"])
	var result = Globals.parse_grid(lines)
	
	assert_eq(result.size(), 3, "Should have 3 rows")
	assert_eq(result[0].size(), 3, "First row should have 3 columns")
	assert_eq(result[0][0], "A", "First cell should be A")
	assert_eq(result[1][1], "E", "Middle cell should be E")
	assert_eq(result[2][2], "I", "Last cell should be I")

func test_get_day_dir():
	var result = Globals.get_day_dir(1)
	assert_eq(result, "res://days/day01/", "Should format day directory correctly")
	
	result = Globals.get_day_dir(15)
	assert_eq(result, "res://days/day15/", "Should format day 15 directory correctly")

