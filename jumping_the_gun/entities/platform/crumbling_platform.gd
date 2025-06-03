extends Platform

var last_steppable_frame: int = 3

@onready var sprite: Sprite2D = $Sprite2D
@onready var frame_count: int = sprite.hframes
@onready var collision_shape: CollisionShape2D = $CollisionShape2D

func _on_area_2d_body_entered(body: Node2D):
	if not body.is_in_group("player"):
		return
	
	if sprite.frame == 0:
		sprite.frame = Utils.get_random_int(1, last_steppable_frame)
		return

	if not sprite.frame == last_steppable_frame:
		sprite.frame += 1
	else:
		collision_shape.disabled = true
		var tween = create_tween()
		for frame in range(4, frame_count):
			tween.tween_callback(func(): sprite.frame = frame)
			tween.tween_interval(0.05)
		tween.tween_callback(queue_free)
