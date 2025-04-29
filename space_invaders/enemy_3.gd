extends CharacterBody2D

@export var sprite: Sprite2D
@export var projectile_scene: PackedScene

signal out_of_bounds
signal bullet_detected(body)

var direction = 10
var parent: Node2D
var should_move_down = false
var should_change_direction = false
var down_distance = 10
var bounds_offset = 20
var projectile = null

func _ready():
	parent = get_parent()
	parent.connect("tick", _on_tick)
	parent.connect("change_direction", _on_change_direction)

func _process(_delta):
	if self.position.x > get_viewport_rect().size.x - bounds_offset or self.position.x < bounds_offset:
		out_of_bounds.emit()
	if projectile and projectile.position.x > get_viewport_rect().size.x:
		projectile.queue_free()
		projectile = null

func _on_tick():
	sprite.frame = 1 if sprite.frame == 0 else 0
	if should_move_down:
		self.position.y += 1 * down_distance
		should_move_down = false
	else:
		should_change_direction = true
		self.position.x += direction
	if randi() % 20 == 0 and !projectile:
		projectile = projectile_scene.instantiate()
		projectile.global_position = self.global_position
		parent.add_child(projectile)

func _on_change_direction():
	if should_change_direction:
		should_move_down = true
		should_change_direction = false
		direction *= -1

func _on_hurtbox_body_entered(_body: Node2D) -> void:
		bullet_detected.emit(self)
