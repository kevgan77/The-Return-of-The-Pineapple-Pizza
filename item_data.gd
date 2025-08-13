# ItemData.gd - Resource script for item definitions
extends Resource
class_name ItemData

@export var id: String
@export var name: String
@export var description: String
@export var icon: Texture2D
@export var max_stack_size: int = 64
@export var is_stackable: bool = true
