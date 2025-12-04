extends GutTest

const Day03 = preload("res://days/day03/day03.gd")


func before_each():
	gut.p("Running test...")


func after_each():
	gut.p("Test completed")


func test_sample():
	var day = Day03.new()

	var line = '745433452452451332445546443'
	var max_num = 755555546443

	assert_eq(day.get_max(line, 12), max_num, "Should correct getting max for l=12")
