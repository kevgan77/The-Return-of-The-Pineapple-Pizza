extends CharacterBody2D

@export var SPEED = 50
@export var ACCELERATION = 20.0
@export var FRICTION = 10.0
@onready var sprite = $AnimatedSprite2D

func play_animation_direction():
	var x = velocity.x
	var y = velocity.y 
	if x>0 and y <0:
		sprite.play("Top_Right")
	if x>0 and y == 0:
		sprite.play("Right")
	if x==0 and y> 0:
		sprite.play("Down")
	if x<0 and y <0:
		sprite.play("Top_Left")
	if x>0 and y >0:
		sprite.play("Bottom_Right")
	if x<0 and y >0:
		sprite.play("Bottom_Left")
	if x == 0 and y < 0:
		sprite.play("Up")
	if x < 0 and y == 0:
		sprite.play("Left")
		
func _physics_process(delta: float) -> void:
	# Add the gravity.
	#if not is_on_floor():
		#velocity += get_gravity() * delta

	# Handle jump.
	#if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		#velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_vector("Left", "Right", "Up", "Down").normalized()
	print(direction)
	if direction:
		velocity = velocity.move_toward(direction * SPEED, ACCELERATION)
		play_animation_direction()
	else:
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION)
		$AnimatedSprite2D.play("Idle")

	move_and_slide()


func _on_portal_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		get_tree().change_scene_to_file("res://Scenes/test_world.tscn")
