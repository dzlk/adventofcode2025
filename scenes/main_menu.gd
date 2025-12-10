extends Control

## Main Menu for Advent of Code 2025
## Automatically discovers and lists available days

@onready var days_container: VBoxContainer = $MarginContainer/VBoxContainer/ScrollContainer/DaysContainer
@onready var title_label: Label = $MarginContainer/VBoxContainer/TitleLabel

const MAX_DAYS = 25

func _ready() -> void:
	populate_days()

## Discover and create buttons for all available days
func populate_days() -> void:
	if not days_container:
		return
	
	# Clear existing buttons
	for child in days_container.get_children():
		child.queue_free()
	
	var found_days = 0
	
	for day in range(1, MAX_DAYS + 1):
		if Globals.day_exists(day):
			create_day_button(day)
			found_days += 1
	
	if found_days == 0:
		var label = Label.new()
		label.text = "No days found. Create a day in /days/day01/"
		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		days_container.add_child(label)

## Create a button for a specific day
func create_day_button(day: int) -> void:
	var button = Button.new()
	button.text = "Day %d" % day
	button.custom_minimum_size = Vector2(200, 40)
	button.pressed.connect(_on_day_pressed.bind(day))
	days_container.add_child(button)

## Handle day button press
func _on_day_pressed(day: int) -> void:
	var scene_path = "res://days/day%02d/day%02d.tscn" % [day, day]
	
	if not ResourceLoader.exists(scene_path):
		push_error("Scene not found: " + scene_path)
		return
	
	get_tree().change_scene_to_file(scene_path)


