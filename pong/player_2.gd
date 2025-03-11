extends CharacterBody2D

var speed = 100

func reset():
	var viewport = get_viewport_rect().size
	self.global_position.y = viewport.y / 2

func _process(delta: float) -> void:
	var difference = self.global_position.y - $"../Ball".global_position.y
	if difference > 0:
		self.global_position.y -= speed * delta
	elif difference < 0:
		self.global_position.y += speed * delta
	else:
		pass

func randomiseSpeed():
	speed = randi_range(50, 200)
