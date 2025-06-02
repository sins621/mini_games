extends Node

@warning_ignore("shadowed_global_identifier")
func get_random_int(min: int, max: int) -> int:
	return randi() % (max - min) + min

func get_random_range(start: int, amount: int) -> int:
	@warning_ignore("integer_division")
	return randi() % start + amount / 2
