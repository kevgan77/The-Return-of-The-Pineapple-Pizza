extends Control

@onready var pizza_oven = $PizzaOven
@onready var pizza_sprite = $PizzaOven/PizzaSprite
@onready var cooking_animation = $PizzaOven/PizzaSprite/CookingAnimation
@onready var cook_button = $ControlButtons/CookButton
@onready var takeout_button = $ControlButtons/TakeoutButton
@onready var progress_bar = $ProgressBar
@onready var cooking_timer = $CookingTimer

var is_cooking = false
var cooking_progress = 0.0
var cooking_time = 5.0  # 5 seconds to cook pizza

signal pizza_clicked
signal cooking_started
signal cooking_stopped
signal pizza_cooked

func _ready():
	# Connect signals
	pizza_sprite.gui_input.connect(_on_pizza_input)
	cook_button.pressed.connect(_on_cook_button_pressed)
	takeout_button.pressed.connect(_on_takeout_button_pressed)
	cooking_timer.timeout.connect(_on_cooking_timer_timeout)
	
	# Setup initial state
	reset_cooking()
	
	# Setup cooking timer
	cooking_timer.wait_time = 0.1  # Update every 0.1 seconds
	cooking_timer.timeout.connect(_update_cooking_progress)

func _on_pizza_input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if not is_cooking:
			start_cooking()

func _on_cook_button_pressed():
	if not is_cooking:
		start_cooking()

func _on_takeout_button_pressed():
	if is_cooking:
		stop_cooking()

func start_cooking():
	is_cooking = true
	cooking_progress = 0.0
	
	# Update UI
	cook_button.disabled = true
	takeout_button.disabled = false
	progress_bar.visible = true
	progress_bar.value = 0
	
	# Start animations
	cooking_animation.play("cooking")
	cooking_timer.start()
	
	# Emit signal
	cooking_started.emit()
	
	print("Pizza cooking started!")

func stop_cooking():
	is_cooking = false
	cooking_timer.stop()
	
	# Update UI
	cook_button.disabled = false
	takeout_button.disabled = true
	progress_bar.visible = false
	
	# Stop animations
	cooking_animation.stop()
	cooking_animation.play("idle")
	
	# Reset progress
	cooking_progress = 0.0
	
	# Emit signal
	cooking_stopped.emit()
	
	print("Pizza cooking stopped!")

func _update_cooking_progress():
	if is_cooking:
		cooking_progress += 0.1 / cooking_time * 100  # Convert to percentage
		progress_bar.value = cooking_progress
		
		# Check if cooking is complete
		if cooking_progress >= 100:
			complete_cooking()

func complete_cooking():
	stop_cooking()
	
	# Change pizza appearance to cooked
	pizza_sprite.modulate = Color(0.8, 0.6, 0.4)  # Darker, cooked color
	
	# Reset color after 2 seconds
	var tween = create_tween()
	tween.tween_delay(2.0)
	tween.tween_property(pizza_sprite, "modulate", Color.WHITE, 0.5)
	
	# Emit signal
	pizza_cooked.emit()
	
	print("Pizza is cooked!")

func reset_cooking():
	if is_cooking:
		stop_cooking()
	
	# Reset pizza appearance
	pizza_sprite.modulate = Color.WHITE
	
	# Reset UI
	cook_button.disabled = false
	takeout_button.disabled = true
	progress_bar.visible = false
	cooking_progress = 0.0

func _on_cooking_timer_timeout():
	_update_cooking_progress()
