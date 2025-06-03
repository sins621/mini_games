extends Node2D

const PLATFORM_Y_SPACING: int = 13
const PLATFORM_X_SPAWN_OFFSET: int = 40
const MAX_PLATFORMS_PER_ROW: int = 3
const MIN_PLATFORM_JUMP_DISTANCE: int = 10

var platforms: Array[Platform] = []

@onready var basic_platform: PackedScene = preload("res://entities/platform/platform.tscn")

func _ready():
	var view_height = int(get_viewport_rect().size.y)
	var view_width = int(get_viewport_rect().size.x)
	spawn_basic_platforms(view_height, view_width)

func spawn_basic_platforms(view_height: int, view_width: int):
	var spawn_position: Vector2 = generate_start_position(view_height, view_width)
	spawn_platform(spawn_position)
	spawn_position.y -= PLATFORM_Y_SPACING
	
	while spawn_position.y > 0:
		var spawned_platforms_per_row: int = 0
		while can_spawn_more_platforms(spawn_position, view_width, spawned_platforms_per_row):
			if should_spawn_platform_at_position(spawn_position):
				spawn_platform(spawn_position)
				spawn_position.x += Utils.get_random_int(MIN_PLATFORM_SPACING, MAX_PLATFORM_SPACING)
				spawned_platforms_per_row += 1
			else:
				@warning_ignore("integer_division")
				spawn_position.x += randi() % MIN_PLATFORM_JUMP_DISTANCE / 2
		
		spawn_position.x = Utils.get_random_int(PLATFORM_WIDTH, PLATFORM_X_SPAWN_OFFSET)
		spawn_position.y -= PLATFORM_Y_SPACING

func generate_start_position(height: int, width: int) -> Vector2:
	@warning_ignore("integer_division")
	return Vector2(
		Utils.get_random_int(PLATFORM_X_SPAWN_OFFSET, width - PLATFORM_X_SPAWN_OFFSET),
		height - PLATFORM_Y_SPACING
	)

func can_spawn_more_platforms(spawn_position: Vector2, width: int, platforms_in_row: int) -> bool:
	return spawn_position.x + PLATFORM_WIDTH < width - PLATFORM_WIDTH and platforms_in_row < MAX_PLATFORMS_PER_ROW

func should_spawn_platform_at_position(spawn_position: Vector2) -> bool:
	var previous_row_y = spawn_position.y + PLATFORM_Y_SPACING
	
	for platform in platforms:
		if platform.global_position.y == previous_row_y:
			if is_within_jump_distance(platform.global_position.x, spawn_position.x):
				return true
	
	return false

func is_within_jump_distance(platform_x: float, spawn_x: float) -> bool:
	var distance = abs(platform_x - spawn_x)
	return distance > MIN_PLATFORM_JUMP_DISTANCE and distance < MAX_PLATFORM_JUMP_DISTANCE

func spawn_platform(spawn_position: Vector2):
	var new_platform: Platform = basic_platform.instantiate()
	new_platform.global_position = spawn_position
	self.add_child(new_platform)
	platforms.append(new_platform)