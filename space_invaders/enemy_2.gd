extends CharacterBody2D

@export var sprite: Sprite2D

signal out_of_bounds

var direction = 10
var parent: Node2D
var should_move_down = false
var should_change_direction = false
var down_distance = 10
var bounds_offset = 20
var dying = false

func _ready():
	parent = get_parent()
	parent.connect("tick", _on_tick)
	parent.connect("change_direction", _on_change_direction)

func _process(_delta):
	if self.position.x > get_viewport_rect().size.x - bounds_offset or self.position.x < bounds_offset:
		out_of_bounds.emit()
	if self.position.y >= 140:
		get_tree().change_scene_to_file("res://game_over.tscn")
	

func _on_tick():
	if !dying and sprite.frame == 0:
		sprite.frame = 1
	elif !dying and sprite.frame == 1:
		sprite.frame = 0
	if should_move_down:
		self.position.y += 1 * down_distance
		should_move_down = false
	else:
		should_change_direction = true
		self.position.x += direction

func _on_change_direction():
	if should_change_direction:
		should_move_down = true
		should_change_direction = false
		direction *= -1

func _on_hurtbox_body_entered(body: Node2D) -> void:
		if body.name != "Projectile":
			return
		dying = true
		direction = 0
		sprite.frame = 2
		parent.add_score(20)
		body.queue_free()
		$Hurtbox/CollisionShape2D.set_deferred("disabled", true)
		await get_tree().create_timer(0.5).timeout
		self.queue_free()
