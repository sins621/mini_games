extends Node2D
var cell_size: Vector2


func _process(delta: float) -> void:
	cell_size = Vector2(get_viewport_rect().size/20)
