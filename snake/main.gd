extends Node2D
var cell_size: Vector2
var segment_scene = preload("res://segment.tscn")

var segments = []
var head = null

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
	for i in range(segments.size() - 1, 0, -1):
		segments[i].global_position = segments[i-1].global_position
	$SnakeHead.position += $SnakeHead.move_direction
	for i in range(segments.size() - 1, 0, -1):
		if $SnakeHead.position == segments[i].position:
			print('oh shit')
