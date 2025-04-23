extends CharacterBody2D

@export var sprite: Sprite2D

signal out_of_bounds

var direction = 10
var parent: Node2D

func _ready():
	parent = get_parent()
	parent.connect("tick", _on_tick)
	parent.connect("change_direction", _on_change_direction)

func _process(_delta: float) -> void:
	if self.position.x > get_viewport_rect().size.x or self.position.x < 0:
		out_of_bounds.emit()

func _on_tick():
	sprite.frame = 1 if sprite.frame == 0 else 0
	self.position.x += direction

func _on_change_direction():
	direction *= -1