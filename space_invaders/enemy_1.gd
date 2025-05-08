extends CharacterBody2D

@export var sprite: Sprite2D

var direction = 10
var parent: Node2D
var down_distance = 10
var bounds_offset = 20
var screen_size = null
var debug_label: Label = null

enum State {MOVING, DYING, CHANGING_DIRECTION, MOVING_DOWN}
var current_state = State.MOVING
var can_change_state = true

func _ready():
	parent = get_parent()
	parent.connect("tick", _on_tick)
	screen_size = get_viewport_rect().size
 
func _on_tick():
	if current_state != State.DYING and sprite.frame == 0:
		sprite.frame = 1
	elif current_state != State.DYING and sprite.frame == 1:
		sprite.frame = 0

func _on_hurtbox_body_entered(body: Node2D) -> void:
	if body.name != "Projectile":
		return
	$Death.pitch_scale = (randf() * 0.4) + 0.8
	$Death.play()
	current_state = State.DYING
	direction = 0
	sprite.frame = 2
	parent.add_score(10)
	body.queue_free()
	$Hurtbox/CollisionShape2D.set_deferred("disabled", true)
	await get_tree().create_timer(0.5).timeout
	self.queue_free()
