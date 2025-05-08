extends CharacterBody2D

@export var sprite: Sprite2D
@export var projectile_scene: PackedScene

var direction = 10
var parent: Node2D
var down_distance = 10
var bounds_offset = 20
var projectile = null
var dying = false

func _ready():
	parent = get_parent()
	parent.connect("tick", _on_tick)

func _on_tick():
	if !dying and sprite.frame == 0:
		sprite.frame = 1
	elif !dying and sprite.frame == 1:
		sprite.frame = 0
	if randi() % 20 == 0 and !projectile:
		projectile = projectile_scene.instantiate()
		projectile.global_position = self.global_position
		parent.add_child(projectile)

func _on_hurtbox_body_entered(body: Node2D) -> void:
	if body.name != "Projectile":
		return
	$Death.pitch_scale = (randf() * 0.4) + 1.2
	$Death.play()
	dying = true
	direction = 0
	sprite.frame = 2
	parent.add_score(40)
	body.queue_free()
	$Hurtbox/CollisionShape2D.set_deferred("disabled", true)
	await get_tree().create_timer(0.5).timeout
	self.queue_free()
