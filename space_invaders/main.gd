extends Node2D

@export var enemy_1_scene: PackedScene
@export var enemy_2_scene: PackedScene
@export var enemy_3_scene: PackedScene
@export var enemy_flyer_scene: PackedScene
@export var timer: Timer
@onready var level_label = $Level

var level = 0
var direction: Vector2 = Vector2(10, 0)

signal tick

var y_offset := 30
var enemies := []
var flyer: CharacterBody2D
var should_change_direction = false
var should_move_down = false

@onready var enemy_setup = [
		{"scene": enemy_3_scene, "row": 0},
		{"scene": enemy_2_scene, "row": 15},
		{"scene": enemy_2_scene, "row": 30},
		{"scene": enemy_1_scene, "row": 45},
		{"scene": enemy_1_scene, "row": 60}
	]

func _ready() -> void:
	Global.high_score = 0
	spawn_enemies()
	update_score_label()

func _process(_delta: float) -> void:
	if flyer and flyer.position.x > get_viewport_rect().size.x:
		flyer = null
	if enemies:
		for enemy in enemies:
			if detect_loss(enemy):
				get_tree().change_scene_to_file("res://game_over.tscn")

func spawn_enemies():
	level += 1
	level_label.text = "Levels: " + str(level)
	if level > 1: $Spawn.play()
	for setup in enemy_setup:
		spawn_enemy_row(setup["scene"], setup["row"] + y_offset)

func spawn_enemy_row(scene: PackedScene, y_position: float) -> void:
	for i in range(8):
		var new_enemy: CharacterBody2D = scene.instantiate()
		new_enemy.global_position = Vector2(40 + i * 25, y_position)
		new_enemy.connect("tree_exiting", _on_enemy_destroyed.bind(new_enemy))
		enemies.append(new_enemy)
		add_child(new_enemy)

func _on_enemy_destroyed(enemy: CharacterBody2D) -> void:
	enemies.erase(enemy)
	if len(enemies) == 0:
		call_deferred("spawn_enemies")
		y_offset += 5
		timer.wait_time *= 0.9

func _on_timer_timeout() -> void:
	timer.start()
	tick.emit()
	spawn_flyer()
	for enemy in enemies:
		if detect_edge(enemy):
			should_move_down = true
			break
	if should_move_down:
		if should_change_direction:
			direction.x *= -1
			for enemy in enemies:
				move_enemy(enemy, direction)
			should_move_down = false
			should_change_direction = false
		else:
			for enemy in enemies:
				move_enemy(enemy, Vector2(0, 10))
				should_change_direction = true
	else:
		for enemy in enemies:
			move_enemy(enemy, direction)

func move_enemy(enemy, enemy_direction):
	enemy.position += enemy_direction

func detect_edge(enemy):
	var offset = 20
	var screen_width = get_viewport_rect().size.x
	if enemy.position.x > screen_width - offset:
		return true
	if enemy.position.x < 0 + offset:
		return true
	return false

func detect_loss(enemy):
	if enemy.position.y > 130:
		return true
	return false

func spawn_flyer():
	if randi() % 20 == 0 and !flyer:
		flyer = enemy_flyer_scene.instantiate()
		flyer.global_position = Vector2(0, 10)
		add_child(flyer)

func add_score(points: int) -> void:
	Global.high_score += points
	update_score_label()

func update_score_label() -> void:
	$Score.text = "Score: " + str(Global.high_score)
