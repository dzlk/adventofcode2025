class_name Lggr
extends RefCounted

enum Level {
	INFO,
	ERROR,
	DEBUG,
}

const levelNames = {
	Level.INFO: "INFO",
	Level.ERROR: "ERROR",
	Level.DEBUG: "DEBUG",
}

const colors = {
	Level.INFO: Color.BEIGE,
	Level.ERROR: Color.FIREBRICK,
	Level.DEBUG: Color.DARK_GRAY,
}


func level_color(level: Level) -> String:
	return colors.get(level) if colors.has(level) else colors[Level.INFO]


var log_debug = true
var colorful = true


# constructor
func _init():
	pass


func toggle_log_debug(value: bool):
	log_debug = value


func toggle_colorful(value: bool):
	colorful = value


func clog(msg: Variant, color: Color):
	print_rich(_color_msg(msg, color))


func _log(level: Level, msg: Variant, log_level: bool = true):
	if !log_debug && level == Level.DEBUG:
		return

	msg = str(msg)

	if log_level:
		msg = "%s: %s" % [levelNames[level], msg]

	if colorful:
		var color = colors[level]
		msg = _color_msg(msg, color)

	print_rich(msg)


func _color_msg(msg: Variant, color: Color):
	return "[color=%s]%s[/color]" % [color.to_html(false), msg]


func info(msg: Variant):
	_log(Level.INFO, msg)


func error(msg: Variant):
	_log(Level.ERROR, msg)


func debug(msg: String):
	_log(Level.DEBUG, msg)


func log_grid(grid: Array, level: Level = Level.DEBUG) -> void:
	log_delim(level, '~', 5)

	for y in range(grid.size()):
		_log(level, "".join(grid[y]), false)

	log_delim(level, '~', 5)


func log_delim(level: Level, symbol: String = "=", length: int = 10):
	_log(level, symbol.repeat(length), false)


func ln():
	print("\n")
