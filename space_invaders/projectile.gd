extends CharacterBody2D

@export var SPEED = 169 # nice

func _process(delta: float) -> void:
	self.position.y -= SPEED * delta
