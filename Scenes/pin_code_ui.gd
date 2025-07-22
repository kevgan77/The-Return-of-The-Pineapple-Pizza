extends Control
# The correct PIN code
var correct_pin = "1234"
# Current entered PIN
var entered_pin = ""
# Maximum length of the PIN
var max_pin_length = 4

# Reference to the UI label to display the entered PIN
@onready var pin_label = $PinLabel  # Assumes a Label node named "PinLabel" as a child
# Reference to a feedback label for correct/incorrect messages
@onready var feedback_label = $FeedbackLabel  # Assumes a Label node named "FeedbackLabel"

func _ready():
	# Connect signals for number buttons (assumes they are Control nodes like Button in the "number_buttons" group)
	for number_button in get_tree().get_nodes_in_group("number_buttons"):
		if number_button is Button:
			number_button.pressed.connect(_on_number_button_pressed.bind(number_button))

func _on_number_button_pressed(number_button: Button):
	# Get the number from the button's text or a custom property
	var number = number_button.get_meta("number", number_button.text)
	if entered_pin.length() < max_pin_length:
		entered_pin += number
		update_pin_display()
		check_pin()

func update_pin_display():
	# Update the UI label with the current entered PIN
	if pin_label:
		pin_label.text = entered_pin

func check_pin():
	# Check if the entered PIN matches the correct PIN
	if entered_pin.length() == max_pin_length:
		if entered_pin == correct_pin:
			feedback_label.text = "Correct PIN! Access granted."
			# Add logic for successful PIN entry (e.g., emit signal, trigger event)
		else:
			feedback_label.text = "Incorrect PIN. Try again."
			# Reset the entered PIN after a short delay
			await get_tree().create_timer(1.0).timeout
			entered_pin = ""
			update_pin_display()
			feedback_label.text = ""
