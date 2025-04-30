extends CharacterBody2D

var speed = 60
@onready var sprite = $Sprite2D

func _process(delta: float) -> void:
	self.position.x += speed * delta

func _on_hurtbox_body_entered(body: Node2D) -> void:
	if body.name != "Projectile":
		return
	speed = 0
	sprite.frame = 1
	body.queue_free()
	$Hurtbox/CollisionShape2D.set_deferred("disabled", true)
	await get_tree().create_timer(0.5).timeout
	self.queue_free()
