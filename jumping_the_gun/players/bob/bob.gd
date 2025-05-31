extends CharacterBody2D

const SPEED : int = 100
const JUMP_VELOCITY = -150

var GRAVITY : int = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var sprite : AnimatedSprite2D = $ViewContainer/AnimatedSprite2D
@onready var ViewContainer : Node2D = $ViewContainer
@onready var bullet_spawn : Marker2D = $ViewContainer/Marker2D
@onready var bullet = preload("res://entities/bullets/bullet.tscn")

func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	if Input.is_action_pressed("left"):
		velocity.x = -SPEED
	elif Input.is_action_pressed("right"):
		velocity.x = SPEED
	else:
		velocity.x = 0
	
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	if not is_on_floor():
		velocity.y += GRAVITY * delta
	
	if not is_on_floor():
		sprite.play("jump")
	else:
		if velocity:
			sprite.play("run")
		else:
			sprite.play("idle")
	
	if velocity.x > 0:
		ViewContainer.scale.x = 1
	elif velocity.x < 0:
		ViewContainer.scale.x = -1
	
	if Input.is_action_just_pressed("shoot"):
		var new_bullet: CharacterBody2D = bullet.instantiate()
		new_bullet.global_position = bullet_spawn.global_position
		get_parent().add_child(new_bullet)
	
	move_and_slide()
