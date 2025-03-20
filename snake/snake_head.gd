extends CharacterBody2D

var direction: Vector2
var move_direction: Vector2

var collision_detected = false

func _process(_delta: float) -> void:
	direction = getMoveDirection()
	if direction:
		move_direction = direction * $"..".cell_size
	global_position.x = clamp(global_position.x, 0, get_viewport_rect().size.x - $"..".cell_size.x)
	global_position.y = clamp(global_position.y, 0, get_viewport_rect().size.y - $"..".cell_size.y)


func getMoveDirection():
	if Input.is_action_just_pressed("up"):
		return Vector2(0, -1)
	elif Input.is_action_pressed("down"):
		return Vector2(0, 1)
	elif Input.is_action_pressed("left"):
		return Vector2(-1, 0)
	elif Input.is_action_pressed("right"):
		return Vector2(1, 0)
	else:
		return Vector2(0,0);
