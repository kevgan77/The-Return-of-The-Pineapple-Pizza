extends Control

@onready var character = $Character
@onready var trees = $Trees
@onready var animation_player = $AnimationPlayer

func _ready():
	# Setup pixel art animations
	if animation_player:
		animation_player.play("idle_scene")

func _process(delta):
	# Add any pixel art game logic here
	# Character movement, interactions, etc.
	pass
