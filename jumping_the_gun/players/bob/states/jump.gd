extends Node

const JUMP_VELOCITY = -250.0
const JUMP_GRAVITY = 400.0
const FALL_GRAVITY = 600.0
const GRAVITY_REDUCTION = 200.0
const APEX_MODIFIER = 0.6

func enter(player):
	if Input.is_action_just_pressed("jump") and player.is_on_floor():
		player.velocity.y = JUMP_VELOCITY
		player.sprite.play_animation(player.sprite.Anim.JUMP)

func update(player, delta):
	if not player.is_on_floor():
		var gravity = FALL_GRAVITY
		
		if player.velocity.y < 0:
			gravity = JUMP_GRAVITY
			
		if abs(player.velocity.y) < APEX_MODIFIER * abs(JUMP_VELOCITY):
			gravity -= GRAVITY_REDUCTION
			
		player.velocity.y += gravity * delta
	else:
		player.change_state("idle")
		
	var direction = 0.0
	if Input.is_action_pressed("right"):
		direction += 1
	if Input.is_action_pressed("left"):
		direction -= 1
		
	player.velocity.x = direction * 55.0

func exit(_player):
	pass