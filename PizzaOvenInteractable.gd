# PizzaOvenInteractable.gd
# Attach this script to the PizzaOvenInteractable (Area2D) node
extends Area2D

@onready var interaction_prompt = $InteractionPrompt  # Reference to the Label node
var player_nearby = false

func _ready():
	# Connect the Area2D signals to our functions
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	
	# Make sure prompt is hidden at start
	if interaction_prompt:
		interaction_prompt.visible = false
	
	print("Pizza Oven Interactable ready!")

# Called when something enters the Area2D
func _on_body_entered(body):
	print("Something entered area: ", body.name)
	
	# Check if it's the player
	if body.name == "Player" or body.is_in_group("player"):
		player_nearby = true
		show_interaction_prompt()
		print("Player can now interact with pizza oven (F key)!")

# Called when something exits the Area2D  
func _on_body_exited(body):
	print("Something left area: ", body.name)
	
	# Check if it's the player
	if body.name == "Player" or body.is_in_group("player"):
		player_nearby = false
		hide_interaction_prompt()
		print("Player can no longer interact with pizza oven")

# Handle input - check for F key press
func _input(event):
	# Only respond to F key when player is nearby
	if player_nearby and event.is_action_pressed("open"):
		open_pizza_oven()

# Show the "Press E" text
func show_interaction_prompt():
	if interaction_prompt:
		interaction_prompt.visible = true
		interaction_prompt.text = "Press F to use Pizza Oven"
		print("Showing interaction prompt")

# Hide the "Press E" text
func hide_interaction_prompt():
	if interaction_prompt:
		interaction_prompt.visible = false
		print("Hiding interaction prompt")

# Open the pizza oven minigame
func open_pizza_oven():
	print("Opening pizza oven minigame...")
	# Change to your pizza oven scene
	get_tree().change_scene_to_file("res://scenes/main_game.tscn")

# Optional: Add visual feedback when player enters area
func _on_body_entered_visual_feedback(body):
	if body.name == "Player":
		# Make oven glow or change color
		var sprite = $PizzaOvenSprite
		if sprite:
			var tween = create_tween()
			tween.tween_property(sprite, "modulate", Color(1.2, 1.2, 1.0), 0.3)

func _on_body_exited_visual_feedback(body):
	if body.name == "Player":
		# Remove glow
		var sprite = $PizzaOvenSprite
		if sprite:
			var tween = create_tween()
			tween.tween_property(sprite, "modulate", Color.WHITE, 0.3)
