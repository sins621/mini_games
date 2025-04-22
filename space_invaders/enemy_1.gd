extends CharacterBody2D

@export var sprite: Sprite2D
@export var timer: Timer

func _on_timer_timeout() -> void:
	sprite.frame = 1 if sprite.frame == 0 else 0
	timer.start()
