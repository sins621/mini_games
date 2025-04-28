extends CharacterBody2D

@export var SPEED = 90
@export var bullet : PackedScene
var projectile: CharacterBody2D

func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	if Input.is_action_pressed("move_left"):
		self.position.x -= SPEED * delta
	if Input.is_action_pressed("move_right"):
		self.position.x += SPEED * delta
	self.position.x = clamp(self.position.x, 5, get_viewport_rect().size.x - 5)
	if Input.is_action_pressed("fire") and not projectile:
		projectile = bullet.instantiate()
		owner.add_child(projectile)
		projectile.transform = $Marker2D.global_transform

	if projectile and projectile.position.y < 0:
		projectile.queue_free()
