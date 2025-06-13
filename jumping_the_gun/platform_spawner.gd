extends Node2D

var platforms := []
const Y_SPACING := 10
const MAX_SPACE_BETWEEN = 15

@onready var basic_platform: PackedScene = preload("res://entities/platform/platform.tscn")
@onready var screen_size: Vector2i = get_viewport().size
@onready var options: Array[PackedScene] = [basic_platform]
@warning_ignore("integer_division")
@onready var levels: int = screen_size.y / Y_SPACING

func _ready():
	spawn_platforms()

func spawn_platforms() -> void:
	for i in range(levels):
		pass

func close_to_prev(previous_platforms: Array[Platform], x_position) -> bool:
	for platform in previous_platforms:
		pass
	return false

func enough_spacing_from(current_level_platforms: Array[Platform], x_position) -> bool:
	for platform in current_level_platforms:
		pass
	return false

func can_spawn_platform(current_level_platforms: Array[Platform]) -> bool:
	return false
