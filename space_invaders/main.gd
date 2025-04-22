extends Node2D

@export var enemy_1_scene: PackedScene
var enemy1_group = []

func _ready() -> void:
	for i in range(0, 8):
		var new_enemy: CharacterBody2D = enemy_1_scene.instantiate()
		new_enemy.global_position = Vector2(40, 20)
		new_enemy.global_position.x += i * 25
		enemy1_group.append(new_enemy)
		add_child(new_enemy)
