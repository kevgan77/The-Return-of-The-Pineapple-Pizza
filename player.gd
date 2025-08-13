extends CharacterBody2D

@export var SPEED = 130
@export var SPRINT_MULTIPLIER = 2.0
@export var ACCELERATION = 10
@export var FRICTION = 15.0
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
	# Get the input direction and handle the movement/deceleration.
	var direction := Input.get_vector("Left", "Right", "Up", "Down").normalized()
	
	# Check if Shift is held for sprinting
	var current_speed = SPEED
	if Input.is_action_pressed("Sprint"):
		current_speed *= SPRINT_MULTIPLIER
	
	if direction:
		velocity = velocity.move_toward(direction * current_speed, ACCELERATION)
		play_animation_direction()
	else:
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION)
		$AnimatedSprite2D.play("Idle")

	move_and_slide()


func _on_portal_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		get_tree().change_scene_to_file("res://Scenes/test_world.tscn")



func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		get_tree().change_scene_to_file("res://interior1.tscn")
		



func _on_return_back_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		get_tree().change_scene_to_file("res://real_map.tscn")
	

@onready var inventory_ui = $UI/InventoryUI  

func add_to_inventory(item_id: String, amount: int = 1):
	var item_data = ItemDatabase.get_item(item_id)
	if item_data:
		var remaining = inventory_ui.add_item(item_data, amount)
		if remaining > 0:
			print("Could not fit all items. ", remaining, " items dropped.")
		else:
			print("Added ", amount, " ", item_data.name, " to inventory")

# 
#func _input(event):
#	if event.is_action_pressed("toggle_inventory"):  
#		inventory_ui.visible = !inventory_ui.visible
