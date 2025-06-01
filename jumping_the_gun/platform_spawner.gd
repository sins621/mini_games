extends Node2D

const PLATFORM_Y_SPACING: int = 10
const PLATFORM_X_SPACING: int = 60

var platforms: Array[Platform] = []

@onready var basic_platform: PackedScene = preload("res://entities/platform/platform.tscn")
@onready var view_height = int(get_viewport_rect().size.y)
@onready var view_width = int(get_viewport_rect().size.x)


func _ready():
	spawn_basic_platform(view_height, view_width)

func spawn_basic_platform(height: int, width: int):
	for i in range(16):
		var new_platform: Platform = basic_platform.instantiate()
		if len(platforms) < 1 or i == 8:
			new_platform.global_position.x = (randi() % width)
			new_platform.global_position.y = height - PLATFORM_Y_SPACING
		else:
			@warning_ignore("integer_division")
			new_platform.global_position.x = platforms[i - 1].global_position.x + ((randi() % PLATFORM_X_SPACING) - PLATFORM_X_SPACING / 2)
			new_platform.global_position.y = height - PLATFORM_Y_SPACING - i * PLATFORM_Y_SPACING
		
		platforms.append(new_platform)
		self.add_child(new_platform)
