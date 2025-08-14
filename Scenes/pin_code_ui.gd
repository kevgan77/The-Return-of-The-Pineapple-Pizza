extends CanvasLayer

signal correct_pin_entered
signal pin_ui_closed

@export var correct_pin = "1234"
@export var success_sound: AudioStream
@export var fail_sound: AudioStream
@export var button_sound: AudioStream

var entered_pin = ""
var max_pin_length = 4

@onready var pin_display = $FullScreenContainer/PinPanel/MainLayout/PinDisplay
@onready var feedback_label = $FullScreenContainer/PinPanel/MainLayout/FeedbackLabel
@onready var audio_player = $AudioStreamPlayer

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	get_tree().paused = true
	update_pin_display()
	
	# Connect number buttons
	for i in range(10):
		var button = get_node("FullScreenContainer/PinPanel/MainLayout/NumberGrid/Button" + str(i))
		if button:
			button.pressed.connect(_on_number_pressed.bind(str(i)))
	
	# Connect clear button
	var clear_button = $FullScreenContainer/PinPanel/MainLayout/NumberGrid/ClearButton
	if clear_button:
		clear_button.pressed.connect(_on_clear_pressed)
	
	# Connect close button
	var close_button = $FullScreenContainer/PinPanel/MainLayout/CloseButton
	if close_button:
		close_button.pressed.connect(_on_close_pressed)

func _input(event):
	if event is InputEventKey and event.pressed:
		if event.keycode >= KEY_0 and event.keycode <= KEY_9:
			var number = str(event.keycode - KEY_0)
			_on_number_pressed(number)
		elif event.keycode == KEY_BACKSPACE or event.keycode == KEY_DELETE:
			_on_clear_pressed()
		elif event.keycode == KEY_ESCAPE:
			_on_close_pressed()

func _on_number_pressed(number: String):
	if entered_pin.length() < max_pin_length:
		play_sound(button_sound)
		entered_pin += number
		update_pin_display()
		
		if entered_pin.length() == max_pin_length:
			check_pin()

func _on_clear_pressed():
	play_sound(button_sound)
	entered_pin = ""
	update_pin_display()
	feedback_label.text = ""

func _on_close_pressed():
	get_tree().paused = false
	pin_ui_closed.emit()

func update_pin_display():
	if pin_display:
		# Show dots for entered digits
		var display_text = ""
		for i in range(max_pin_length):
			if i < entered_pin.length():
				display_text += "● "
			else:
				display_text += "○ "
		pin_display.text = display_text.strip_edges()

func check_pin():
	if entered_pin == correct_pin:
		feedback_label.text = "ACCESS GRANTED"
		feedback_label.modulate = Color.GREEN
		play_sound(success_sound)
		
		await get_tree().create_timer(1.0).timeout
		get_tree().paused = false
		correct_pin_entered.emit()
	else:
		feedback_label.text = "ACCESS DENIED"
		feedback_label.modulate = Color.RED
		play_sound(fail_sound)
		
		await get_tree().create_timer(1.5).timeout
		entered_pin = ""
		update_pin_display()
		feedback_label.text = ""
		feedback_label.modulate = Color.WHITE

func play_sound(sound: AudioStream):
	if sound and audio_player:
		audio_player.stream = sound
		audio_player.play()
