extends Sprite2D

signal bullet_detected

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_area_2d_body_entered(body):
	if self.frame == 5:
		self.queue_free()
		return
	self.frame += 1
