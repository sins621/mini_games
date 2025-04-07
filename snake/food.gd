extends CharacterBody2D

func _on_area_2d_body_entered(_body: Node2D) -> void:
	randomPos()

func randomPos():
	for segment in $"..".segments:
		global_position = Vector2(randi_range(0, $"..".cell_size.x) * $"..".cell_size.x ,randi_range(0, $"..".cell_size.y) * $"..".cell_size.y)
		if global_position == segment.position:
			randomPos()
