extends Control

# Called when the node enters the scene tree for the first time.
func _ready():
	# Connect the button signals to their respective functions
	$VBoxContainer/StartButton.pressed.connect(_on_start_button_pressed)
	$VBoxContainer/Option.pressed.connect(_on_option_button_pressed)
	$VBoxContainer/Exit.pressed.connect(_on_exit_button_pressed)

# Functions to handle button presses
func _on_start_button_pressed():
	print("Start Button Pressed!")
	get_tree().change_scene_to_file("res://real_map.tscn")

func _on_option_button_pressed():
	print("Option Button Pressed!")

func _on_exit_button_pressed():
	print("Exit Button Pressed!")
