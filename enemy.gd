extends CharacterBody2D

@export var SPEED = 45  # Slightly slower than player
@export var ACCELERATION = 15.0
@export var FRICTION = 10.0
@onready var sprite = $AnimatedSprite2D
var player = null

func _ready() -> void:
	player = get_tree().get_first_node_in_group("Player")

func play_animation_direction():
	var x = velocity.x
	var y = velocity.y
	
	# Default to idle if no movement
	sprite.play("Idle")
	
	# Play right animation and flip sprite based on direction
	if x > 0:
		sprite.play("Right")
		sprite.flip_h = false  # Face right
	elif x < 0:
		sprite.play("Right")
		sprite.flip_h = true   # Face left by flipping
	elif y > 0:
		sprite.play("Down")
	elif y < 0:
		sprite.play("Up")

func _physics_process(delta: float) -> void:
	if player:
		var direction = (player.global_position - global_position).normalized()
		# Move towards player
		velocity = velocity.lerp(direction * SPEED, ACCELERATION * delta)
		play_animation_direction()
	else:
		velocity = velocity.lerp(Vector2.ZERO, FRICTION * delta)
		sprite.play("Idle")
		print("Enemy: Player not found, idling")
	
	move_and_slide()
