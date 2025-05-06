extends CharacterBody2D

@export var sprite: Sprite2D

signal out_of_bounds

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
	parent.connect("change_direction", _on_change_direction)
	screen_size = get_viewport_rect().size
	debug_label = parent.get_node("%Debug")
	debug_label.text = "Debug\n" + "State: " + str(current_state) + "\nDirection: " + str(direction) + "\n can_change_state: " + str(can_change_state)
 
func _on_tick():
	debug_label.text = "Debug\n" + "State: " + str(current_state) + "\nDirection: " + str(direction) + "\n can_change_state: " + str(can_change_state)
	
	if current_state != State.DYING and sprite.frame == 0:
		sprite.frame = 1
	elif current_state != State.DYING and sprite.frame == 1:
		sprite.frame = 0
	
	if current_state == State.MOVING:
		global_position.x += direction
		if not can_change_state:
			can_change_state = true
	elif current_state == State.CHANGING_DIRECTION:
		direction *= -1
		current_state = State.MOVING_DOWN
	elif current_state == State.MOVING_DOWN:
		global_position.y += down_distance
		current_state = State.MOVING
	
	if global_position.x > screen_size.x:
		out_of_bounds.emit()
	if global_position.x < 0:
		out_of_bounds.emit()

func _on_change_direction():
	if can_change_state:
		current_state = State.CHANGING_DIRECTION
		can_change_state = false

func _on_hurtbox_body_entered(body: Node2D) -> void:
	if body.name != "Projectile":
		return
	current_state = State.DYING
	direction = 0
	sprite.frame = 2
	parent.add_score(10)
	body.queue_free()
	$Hurtbox/CollisionShape2D.set_deferred("disabled", true)
	await get_tree().create_timer(0.5).timeout
	self.queue_free()
