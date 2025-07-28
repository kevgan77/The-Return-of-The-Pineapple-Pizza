extends Area2D

signal pin_code_activated
@export var blocker : Node2D 
@export var pin_code_ui_scene: PackedScene
var player_in_area = false
var ui_instance = null

func _ready():
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(body: Node2D):
	print("enter")
	if body.is_in_group("Player"):
		print("player entered")
		player_in_area = true

func _on_body_exited(body: Node2D):
	if body.is_in_group("Player"):
		player_in_area = false

func _input(event):
	if player_in_area and Input.is_action_just_pressed("interact") and not get_tree().paused:
		print("push")
		open_pin_ui()

func open_pin_ui():
	if pin_code_ui_scene and not ui_instance:
		ui_instance = pin_code_ui_scene.instantiate()
		get_tree().root.add_child(ui_instance)
		
		# Connect to PIN UI signals
		if ui_instance.has_signal("correct_pin_entered"):
			ui_instance.correct_pin_entered.connect(_on_correct_pin_entered)
		if ui_instance.has_signal("pin_ui_closed"):
			ui_instance.pin_ui_closed.connect(_on_pin_ui_closed)

func _on_correct_pin_entered():
	pin_code_activated.emit()
	if blocker:
		blocker.queue_free()
	close_pin_ui()

func _on_pin_ui_closed():
	close_pin_ui()

func close_pin_ui():
	if ui_instance:
		ui_instance.queue_free()
		ui_instance = null
