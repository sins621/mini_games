extends CharacterBody2D

@export var SPEED = 90
@export var bullet : PackedScene
var projectile: CharacterBody2D
var can_fire = true
@onready var timer: Timer = $"../ShotDelay"
var lives = 3
@onready var label = $"../Lives"

func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	if Input.is_action_pressed("move_left"):
		self.position.x -= SPEED * delta
	if Input.is_action_pressed("move_right"):
		self.position.x += SPEED * delta
	self.position.x = clamp(self.position.x, 5, get_viewport_rect().size.x - 5)
	if Input.is_action_pressed("fire") and can_fire and not projectile:
		$"../Shoot".play()
		projectile = bullet.instantiate()
		owner.add_child(projectile)
		projectile.transform = $Marker2D.global_transform
		can_fire = false
		timer.start()

	if projectile and projectile.global_position.y < 0:
		projectile.queue_free()

func _on_shot_delay_timeout():
	if can_fire == false:
		can_fire = true

func _on_area_2d_body_entered(body: Node2D) -> void:
	body.queue_free()
	lives -= 1
	label.text = "Lives: " + str(lives)
	if lives == 0:
		call_deferred("game_over")

func game_over():
	get_tree().change_scene_to_file("res://game_over.tscn")
