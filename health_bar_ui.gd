extends CanvasLayer

@onready var health_bar = $MarginContainer/HealthBar
@onready var health_label = $MarginContainer/HealthLabel
var player = null

func _ready():
	# Find the player node (adjust the path to your player node)
	player = get_tree().get_first_node_in_group("Player") # Add player to a "player" group
	if player:
		#await get_tree().create_timer(0.1).timeout
		# Initialize health bar
		health_bar.max_value = player.max_health
		health_bar.value = player.health
		health_label.text = str(player.health) + "/" + str(player.max_health)
		# Connect to player's health_changed signal (if you have one)
		player.connect("health_changed", _on_player_health_changed)

func _on_player_health_changed(new_health):
	print("connected")
	health_bar.value = new_health
	health_label.text = str(new_health) + "/" + str(health_bar.max_value)
