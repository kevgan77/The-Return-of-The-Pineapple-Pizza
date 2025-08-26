extends Control

@onready var pixel_screen = $PixelScreen
@onready var pizza_screen = $PizzaScreen
@onready var style_toggle_btn = $StyleToggleButton

var is_pizza_mode = false

func _ready():
	# Connect the style toggle button
	style_toggle_btn.pressed.connect(_on_style_toggle_pressed)
	
	# Start in pixel art mode
	_set_pixel_mode()

func _on_style_toggle_pressed():
	is_pizza_mode = !is_pizza_mode
	
	if is_pizza_mode:
		_set_pizza_mode()
	else:
		_set_pixel_mode()

func _set_pixel_mode():
	pixel_screen.visible = true
	pizza_screen.visible = false
	style_toggle_btn.text = "Switch to Pizza Oven"
	
	# Reset pizza cooking state when switching back
	if pizza_screen.has_method("reset_cooking"):
		pizza_screen.reset_cooking()

func _set_pizza_mode():
	pixel_screen.visible = false
	pizza_screen.visible = true
	style_toggle_btn.text = "Back to Pixel Art"
