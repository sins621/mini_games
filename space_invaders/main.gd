extends Node2D

@export var enemy_1_scene: PackedScene
@export var enemy_2_scene: PackedScene
@export var enemy_3_scene: PackedScene
@export var timer: Timer

signal tick
signal change_direction
var y_offset = 30

func _ready() -> void:
	for i in range(0, 8):
		var new_enemy: CharacterBody2D = enemy_3_scene.instantiate()
		new_enemy.global_position = Vector2(40, 0 + y_offset)
		new_enemy.global_position.x += i * 25
		new_enemy.connect("out_of_bounds", _on_out_of_bounds)
		new_enemy.connect("bullet_detected", _on_bullet_detected)
		add_child(new_enemy)
	for i in range(0, 8):
		var new_enemy: CharacterBody2D = enemy_2_scene.instantiate()
		new_enemy.global_position = Vector2(40, 15 + y_offset)
		new_enemy.global_position.x += i * 25
		new_enemy.connect("out_of_bounds", _on_out_of_bounds)
		new_enemy.connect("bullet_detected", _on_bullet_detected)
		add_child(new_enemy)
	for i in range(0, 8):
		var new_enemy: CharacterBody2D = enemy_2_scene.instantiate()
		new_enemy.global_position = Vector2(40, 30 + y_offset)
		new_enemy.global_position.x += i * 25
		new_enemy.connect("out_of_bounds", _on_out_of_bounds)
		new_enemy.connect("bullet_detected", _on_bullet_detected)
		add_child(new_enemy)
	for i in range(0, 8):
		var new_enemy: CharacterBody2D = enemy_1_scene.instantiate()
		new_enemy.global_position = Vector2(40, 45 + y_offset)
		new_enemy.global_position.x += i * 25
		new_enemy.connect("out_of_bounds", _on_out_of_bounds)
		new_enemy.connect("bullet_detected", _on_bullet_detected)
		add_child(new_enemy)
	for i in range(0, 8):
		var new_enemy: CharacterBody2D = enemy_1_scene.instantiate()
		new_enemy.global_position = Vector2(40, 60 + y_offset)
		new_enemy.global_position.x += i * 25
		new_enemy.connect("out_of_bounds", _on_out_of_bounds)
		new_enemy.connect("bullet_detected", _on_bullet_detected)
		add_child(new_enemy)

func _on_out_of_bounds():
	change_direction.emit()

func _on_timer_timeout() -> void:
	timer.start()
	tick.emit()

func _on_bullet_detected(node: CharacterBody2D):
	if $Player.projectile:
		$Player.projectile.queue_free()
		node.queue_free()
