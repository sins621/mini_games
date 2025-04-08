extends CharacterBody2D

@export var SPEED = 100

func _process(delta: float) -> void:
	self.position.y -= SPEED * delta
