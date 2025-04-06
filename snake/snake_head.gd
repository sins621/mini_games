extends CharacterBody2D

func get_move_direction():
	if Input.is_action_just_pressed("up"):
		return Vector2(0, -1)
	elif Input.is_action_pressed("down"):
		return Vector2(0, 1)
	elif Input.is_action_pressed("left"):
		return Vector2(-1, 0)
	elif Input.is_action_pressed("right"):
		return Vector2(1, 0)
	else:
		return Vector2(0, 0)
