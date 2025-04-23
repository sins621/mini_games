extends Node2D

@export var enemy_1_scene: PackedScene
@export var timer: Timer
var enemies: Dictionary[String, Array]
var enemy1_group: Array[CharacterBody2D]

signal tick
signal change_direction

func _ready() -> void:
	for i in range(0, 8):
		var new_enemy: CharacterBody2D = enemy_1_scene.instantiate()
		new_enemy.global_position = Vector2(40, 20)
		new_enemy.global_position.x += i * 25
		new_enemy.connect("out_of_bounds", _on_out_of_bounds)
		new_enemy.connect("bullet_detected", _on_bullet_detected)
		enemy1_group.append(new_enemy)
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
