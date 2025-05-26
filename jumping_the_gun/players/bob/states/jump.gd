extends Node

const JUMP_VELOCITY = -200.0

func enter(player):
	if Input.is_action_just_pressed("jump") and player.is_on_floor():
		player.velocity.y = JUMP_VELOCITY

func update(player, delta):	
	if not player.is_on_floor():
		player.velocity += player.get_gravity() * delta
	else:
		player.change_state("idle")

func exit(_player):
	pass