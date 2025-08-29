extends AnimationPlayer

@onready var pizza_sprite = get_parent()

func _ready():
	# Create cooking animation programmatically
	_create_cooking_animation()
	_create_idle_animation()

func _create_cooking_animation():
	var animation = Animation.new()
	animation.length = 1.0
	animation.loop_mode = Animation.LOOP_LINEAR
	
	# Create scale track for bubbling effect
	var scale_track_index = animation.add_track(Animation.TYPE_VALUE)
	animation.track_set_path(scale_track_index, NodePath(".:scale"))
	
	# Add keyframes for bubbling
	animation.track_insert_key(scale_track_index, 0.0, Vector2(1.0, 1.0))
	animation.track_insert_key(scale_track_index, 0.5, Vector2(1.05, 1.05))
	animation.track_insert_key(scale_track_index, 1.0, Vector2(1.0, 1.0))
	
	# Create rotation track for slight wobbling
	var rotation_track_index = animation.add_track(Animation.TYPE_VALUE)
	animation.track_set_path(rotation_track_index, NodePath(".:rotation"))
	
	animation.track_insert_key(rotation_track_index, 0.0, 0.0)
	animation.track_insert_key(rotation_track_index, 0.25, deg_to_rad(2))
	animation.track_insert_key(rotation_track_index, 0.75, deg_to_rad(-2))
	animation.track_insert_key(rotation_track_index, 1.0, 0.0)
	
	# Add animation to library
	var library = get_animation_library("default")
	if not library:
		library = AnimationLibrary.new()
		add_animation_library("default", library)
	
	library.add_animation("cooking", animation)

func _create_idle_animation():
	var animation = Animation.new()
	animation.length = 0.1
	
	# Reset transform
	var scale_track_index = animation.add_track(Animation.TYPE_VALUE)
	animation.track_set_path(scale_track_index, NodePath(".:scale"))
	animation.track_insert_key(scale_track_index, 0.0, Vector2(1.0, 1.0))
	
	var rotation_track_index = animation.add_track(Animation.TYPE_VALUE)
	animation.track_set_path(rotation_track_index, NodePath(".:rotation"))
	animation.track_insert_key(rotation_track_index, 0.0, 0.0)
	
	# Add to library
	var library = get_animation_library("default")
	if not library:
		library = AnimationLibrary.new()
		add_animation_library("default", library)
	
	library.add_animation("idle", animation)
