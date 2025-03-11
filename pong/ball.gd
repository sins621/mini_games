extends CharacterBody2D

const SPEED = 10

func _process(delta: float) -> void:
	velocity.x += SPEED * delta
	move_and_slide()
