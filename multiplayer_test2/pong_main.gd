extends Node2D

@onready var paddle1 := $Paddle1
@onready var paddle2 := $Paddle2
@onready var ball := $Ball

var ball_velocity := Vector2(200, 150)
var next_player := 2  # Track assignment of player roles starting from peer 2

func _ready():
	if OS.has_feature("dedicated_server"):
		print("Running as server")
		start_server()
		assign_multiplayer_authority()
	else:
		print("Running as client")
		await get_tree().create_timer(5.0).timeout
		start_client()

func _physics_process(delta):
	if multiplayer.is_server():
		# Server moves ball
		ball.position += ball_velocity * delta

		# Bounce off top and bottom
		if ball.position.y < 0 or ball.position.y > 600:
			ball_velocity.y *= -1

func _process(delta):
	var move_dir := 0.0
	if Input.is_action_pressed("ui_up"):
		move_dir -= 1.0
	if Input.is_action_pressed("ui_down"):
		move_dir += 1.0

	var speed = 200.0 * delta

	# Client moves only the paddle it has authority over
	if paddle1.is_multiplayer_authority():
		paddle1.position.y += move_dir * speed
	elif paddle2.is_multiplayer_authority():
		paddle2.position.y += move_dir * speed

	# Reset ball with R key
	if Input.is_action_just_pressed("ui_accept"):
		if multiplayer.is_server():
			reset_ball()
		elif paddle2.is_multiplayer_authority():  # Only the assigned player can request
			rpc_id(1, "reset_ball")

# --- Networking ---

func start_server():
	var peer := WebSocketMultiplayerPeer.new()
	var result := peer.create_server(12345, "*")
	if result != OK:
		print("Failed to start server:", result)
		return

	multiplayer.multiplayer_peer = peer
	print("Server started on port 12345")

	# Handle player connections
	multiplayer.peer_connected.connect(_on_peer_connected)

func _on_peer_connected(id):
	print("Peer connected:", id)

	if next_player == 2:
		print("Assigning Paddle2 to peer", id)
		multiplayer.set_multiplayer_authority(paddle2.get_path(), id)
		next_player += 1
	else:
		print("Too many players connected")

func start_client():
	var peer := WebSocketMultiplayerPeer.new()
	var result := peer.create_client("ws://localhost:12345")
	if result != OK:
		print("Failed to connect to server")
		return
	multiplayer.multiplayer_peer = peer
	await multiplayer.connected_to_server
	print("Connected to server")

func assign_multiplayer_authority():
	# Server is peer ID 1
	multiplayer.set_multiplayer_authority(ball.get_path(), 1)
	multiplayer.set_multiplayer_authority(paddle1.get_path(), 1)
	# Paddle2 will be assigned dynamically on connection

# --- Ball Reset ---

@rpc("authority")
func reset_ball():
	ball.position = Vector2(400, 300)
	ball_velocity = Vector2(200, 150)
