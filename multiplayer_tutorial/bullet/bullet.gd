extends Area2D

const SPEED = 250

func _physics_process(delta: float) -> void:
	position += transform.x * SPEED * delta

func _on_body_entered(body: Node2D) -> void:
	if !is_multiplayer_authority():
		return

	if body is Player:
		body.take_damage.rpc_id(body.get_multiplayer_authority(), 100)
	
	remove_bullet.rpc()

@rpc("call_local")
func remove_bullet():
	queue_free()
