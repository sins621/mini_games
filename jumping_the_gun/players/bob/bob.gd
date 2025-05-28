extends CharacterBody2D

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var marker: Marker2D = $Marker2D
@onready var bullet: PackedScene = preload("res://entities/bullets/bullet.tscn")

var state
var states = {}

const DEFAULT_GRAVITY = 700.0

func _ready():
	states = {
		"idle": preload("./states/idle.gd").new(),
		"move": preload("./states/run.gd").new(),
		"jump": preload("./states/jump.gd").new()
	}
	change_state("idle")

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += DEFAULT_GRAVITY * delta

func _process(delta):
	state.update(self, delta)
	move_and_slide()
	if Input.is_action_just_pressed("shoot"):
		var bullet_instance = bullet.instantiate()
		bullet_instance.position = marker.global_position
		get_tree().current_scene.add_child(bullet_instance)

func change_state(new_state: String):
	if state and state.exit:
		state.exit(self)
	
	state = states[new_state]
	
	if state.enter:
		state.enter(self)
