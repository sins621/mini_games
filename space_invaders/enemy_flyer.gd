extends CharacterBody2D

var speed = 60

func _process(delta: float) -> void:
	self.position.x += speed * delta
