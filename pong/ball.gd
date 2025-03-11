extends CharacterBody2D

const MULTIPLIER = 1000
const STARTING_SPEED = 10
var speed = STARTING_SPEED * MULTIPLIER
var direction: Vector2 = Vector2(-1, 0)
var p1_score = 0
var p2_score = 0


func _physics_process(delta: float) -> void:
	velocity = direction * speed * delta
	move_and_slide()
	if self.global_position > get_viewport_rect().size + Vector2(100, 100) || self.global_position < -get_viewport_rect().size - Vector2(100, 100):
		reset()


func _on_ball_area_body_entered(body: Node2D) -> void:
	if body.name == "Player1" or body.name == "Player2":
		direction.x = -direction.x
		var difference = body.global_position - self.global_position
		direction.y -= difference.y * 0.1
	
	if body.name == "Boundary":
		direction.y = -direction.y
	
	if body.name == "Player1":
		$"../Player2".randomiseSpeed()
	
	speed += 1000


func _on_ball_area_area_entered(area: Area2D) -> void:
	reset()
	update_score(area)

func update_score(area):
	if area.name == "P1ScoreArea":
		direction.x = -1
		p2_score += 1
	else:
		direction.x = 1
		p1_score += 1
	direction.y = 0
	$"../Score".text = "%d:%d" % [p1_score, p2_score]

func reset():
	var viewport = get_viewport_rect().size
	self.global_position = Vector2(viewport.x / 2,viewport.y / 2)
	$"../Player1".reset()
	$"../Player2".reset()
	speed = STARTING_SPEED * MULTIPLIER
