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
	

# _ _    _  _  _      _______
# 7x5xxxx5xx5xx5xxxxxx5546443
# 74543 34524 52451 33244 55464 43
# 012345678900123456789
	"""
	change_max: 745433452452 (0)
	change_max: 745133244554 (1)
	change_max: 745133244443 (9)
	change_max: 745454334524 (3)
	change_max: 745454513324 (6)
	change_max: 745454513343 (10)
	change_max: 754334524524 (1)
	change_max: 751332445546 (2)
	change_max: 754334524524 (2)
	change_max: 754332445546 (3)
	change_max: 754333345245 (5)
	"""
	
