extends Node

const SPEED = 100.0

func enter(_player):
	pass

func update(player, _delta):
	print("State RUN")

	if Input.is_action_just_pressed("jump"):
			player.change_state("jump")
	
	var direction = 0.0
	if Input.is_action_pressed("right"):
		direction += 1
	if Input.is_action_pressed("left"):
		direction -= 1

	player.velocity.x = direction * SPEED
	player.move_and_slide()

	if direction == 0:
		player.change_state("idle")

func exit(_player):
	pass