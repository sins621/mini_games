extends Node

@rpc("any_peer")
func send_message_to_server(msg: String):
	if multiplayer.is_server():
		print("Server received message from peer %s: %s" % [multiplayer.get_remote_sender_id(), msg])

func _ready():
	if OS.has_feature("dedicated_server"):
		print("Running as server")
		start_server()
	else:
		print("Running as client after 5s delay...")
		await get_tree().create_timer(1.0).timeout
		start_client()

func _process(_delta):
	if Input.is_action_just_pressed("ui_accept") and not multiplayer.is_server():
		send_message_to_server.rpc("Hello from the client!")

func start_server():
	var server := WebSocketMultiplayerPeer.new()
	var port := 12345
	var bind_ip := "*"

	var result := server.create_server(port, bind_ip)
	if result != OK:
		print("Failed to start server:", result)
		return

	print("WebSocket server started on port", port)
	multiplayer.multiplayer_peer = server

	server.peer_connected.connect(func(id):
		print("Client connected with ID:", id)
	)

func start_client():
	var client := WebSocketMultiplayerPeer.new()
	var url := "ws://localhost:12345"

	var result := client.create_client(url)
	if result != OK:
		print("Failed to connect to server:", result)
		return

	multiplayer.multiplayer_peer = client

	await multiplayer.connected_to_server
	print("Successfully connected to server")
