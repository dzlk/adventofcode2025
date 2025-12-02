extends Control

@export var ui_title: Label;
@export var ui_part_one: Label;
@export var ui_part_two: Label;

@export var ui_back_button: Button


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ui_back_button.pressed.connect(_on_back_pressed)

func set_title(new_title: String):
	ui_title.text = new_title

func update_part_one(res: Variant):
	ui_part_one.text = str(res)

func update_part_two(res: Variant):
	ui_part_two.text = str(res)

func _on_back_pressed():
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
