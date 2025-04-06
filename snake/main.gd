extends Node2D
var cell_size: Vector2
var segment_scene = preload("res://segment.tscn")

var segments := []
var head = null
var can_move := true
var seg_size = get_viewport_rect().size.x / 20
var current_direction = Vector2(-seg_size, 0)
var move_direction
@onready var snake_head: CharacterBody2D = $SnakeHead

func _ready() -> void:
	head = get_node("SnakeHead")
	segments.append(head)

func _process(_delta: float) -> void:
	cell_size = Vector2(get_viewport_rect().size/20)

func _on_area_2d_body_entered(_body: Node2D) -> void:
	call_deferred("add_new_segment")

func add_new_segment():
	var new_segment: Node2D = segment_scene.instantiate()
	new_segment.global_position = segments[-1].global_position
	segments.append(new_segment)
	add_child(new_segment)

func _on_timer_timeout() -> void:
	move_snake()
	detect_collision()

func move_snake():
	for i in range(segments.size() - 1, 0, -1):
		segments[i].global_position = segments[i-1].global_position
	move_direction = snake_head.get_move_direction() * seg_size
	#FIX: I messed up the movement somehow
	if move_direction:
		snake_head.position += snake_head.get_move_direction()

func detect_collision():
	for i in range(segments.size() - 1, 0, -1):
		if snake_head.position == segments[i].position:
			get_tree().change_scene_to_file("res://game_over.tscn")
			return
	if snake_head.position > get_viewport_rect().size:
		get_tree().change_scene_to_file("res://game_over.tscn")
		return
