extends CharacterBody2D

enum Anim {
	IDLE,
	RUN,
	JUMP
}

const ANIM_NAMES = {
	Anim.IDLE: "idle",
	Anim.RUN: "run",
	Anim.JUMP: "jump"
}

func enter(player):
	player.velocity = Vector2.ZERO
	player.sprite.play_animation(Anim.IDLE)

func update(player, _delta):
	if Input.is_action_pressed("right") or Input.is_action_pressed("left"):
		player.change_state("move")
	if Input.is_action_just_pressed("jump"):
			player.change_state("jump")

func exit(_player):
	pass
