extends CharacterBody2D

@export var SPEED = 20  # Slightly slower than player
@export var ACCELERATION = 14.0
@export var FRICTION = 10.0
@export var DAMAGE = 10  # Amount of damage the enemy deals
@export var DAMAGE_COOLDOWN = 1.0  # Time (in seconds) between damage ticks

@onready var sprite = $AnimatedSprite2D
@onready var area = $Area2D  # Reference to the Area2D node
var player = null
var can_deal_damage = true  # Tracks if the enemy can deal damage
var damage_timer = 0.0  # Timer for damage cooldown
var player_in_range = false  # Tracks if the player is within the Area2D

func _ready() -> void:
	player = get_tree().get_first_node_in_group("Player")
	# Connect Area2D signals
	if area:
		area.body_entered.connect(_on_area_2d_body_entered)
		area.body_exited.connect(_on_area_2d_body_exited)
	else:
		print("Error: Area2D node not found. ")

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
	# Handle movement
	if player:
		var direction = (player.global_position - global_position).normalized()
		velocity = velocity.lerp(direction * SPEED, ACCELERATION * delta)
		play_animation_direction()
	else:
		velocity = velocity.lerp(Vector2.ZERO, FRICTION * delta)
		sprite.play("Idle")
		print("Enemy: Player not found, idling")
	
	move_and_slide()
	
	# Handle damage over time while player is in range
	if player_in_range and can_deal_damage and player:
		player.take_damage(DAMAGE)
		can_deal_damage = false
		damage_timer = DAMAGE_COOLDOWN
	
	# Update damage cooldown timer
	if not can_deal_damage:
		damage_timer -= delta
		if damage_timer <= 0:
			can_deal_damage = true

func _on_area_2d_body_entered(body: Node) -> void:
	if body == player:
		player_in_range = true
		# Optional: Deal damage immediately when player enters
		if can_deal_damage and player:
			player.take_damage(DAMAGE)
			can_deal_damage = false
			damage_timer = DAMAGE_COOLDOWN

func _on_area_2d_body_exited(body: Node) -> void:
	if body == player:
		player_in_range = false
