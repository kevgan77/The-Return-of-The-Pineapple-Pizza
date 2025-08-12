extends Area2D

@export var sprite: Node2D

func _on_area_entered(area: Area2D) -> void:
	sprite.show()
	

func _on_area_exited(area: Area2D) -> void:
	sprite.hide()
