extends CharacterBody2D


func _on_area_2d_body_entered(body: Node2D) -> void:
	global_position = Vector2(randi_range(0, $"..".cell_size.x) * $"..".cell_size.x ,randi_range(0, $"..".cell_size.y) * $"..".cell_size.y )
