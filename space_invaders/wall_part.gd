extends Sprite2D

func _ready():
	pass

func _process(_delta):
	pass

func _on_area_2d_body_entered(body):
	if self.frame == 5:
		self.queue_free()
		return
	self.frame += 1
	# body.queue_free()
