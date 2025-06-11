extends CharacterBody2D

var speed = 100
var gravity = 800
var chase_range = 200
@onready var sprite = $Sprite2D
#@onready var animation_player = $AnimationPlayer
@onready var player = get_node("/root/Main/Player") # Adjust path to your player node

func _ready():
	# Debug check for player reference
	if player:
		print("Enemy found player at: ", player.global_position)
	else:
		print("Error: Player node not found! Check node path or scene setup.")

func _physics_process(delta):
	if not player:
		return
	
	# Calculate direction and distance to player
	var direction = (player.global_position - global_position).normalized()
	var distance_to_player = global_position.distance_to(player.global_position)
	
	# Move toward player if within chase range
	if distance_to_player <= chase_range:
		velocity.x = direction.x * speed
	else:
		velocity.x = 0
	
	# Apply gravity
	velocity.y += gravity * delta
	move_and_slide()
	
	# Update animations
	update_animations(direction.x)

func update_animations(direction_x):
	if not is_on_floor():
		return # No animations while airborne
	if direction_x > 0:
		sprite.play("Run_Right")
		sprite.scale.x = 1
	elif direction_x < 0:
		sprite.play("Run_Left")
		sprite.scale.x = -1
	else:
		sprite.play("Idle")
