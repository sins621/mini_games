extends CharacterBody2D

const SPEED = 100 * 100

func _physics_process(delta):
	get_input(delta)
	move_and_slide()

func get_input(delta):
	var input_direction: Vector2
	if Input.is_action_pressed("p1_up"):
		input_direction.y = -1
	elif Input.is_action_pressed("p1_down"):
		input_direction.y = 1
	velocity = input_direction * SPEED * delta
