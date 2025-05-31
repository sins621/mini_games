extends Node2D

const SPEED = -200.0

func _process(delta):
	self.position.y += SPEED * delta
	if self.position.y < 0:
		queue_free()
		return
