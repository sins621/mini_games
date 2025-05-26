extends CharacterBody2D

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

var state
var states = {}

func _ready():
	states = {
		"idle": preload("./states/idle.gd").new(),
		"move": preload("./states/run.gd").new(),
		"jump": preload("./states/jump.gd").new()
	}
	change_state("idle")

func _physics_process(delta):
	if not is_on_floor():
		velocity += get_gravity() * delta

func _process(delta):
	state.update(self, delta)
	move_and_slide()

	
func change_state(new_state: String):
	if state and state.exit:
		state.exit(self)
		state = states[new_state]
	if state.enter:
		state.enter(self)