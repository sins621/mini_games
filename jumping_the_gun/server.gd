extends Node

func _ready():
	if OS.has_feature("dedicated_server"):
		var server := WebSocketMultiplayerPeer.new()
		var port := 5000
		var bind_ip := "*"

		var result := server.create_server(port, bind_ip)
		if result != OK:
			print("Failed to start server:", result)
			return

		print("WebSocket server started on port", port)
		multiplayer.multiplayer_peer = server

		server.peer_connected.connect(func(id):
			print("Client connected with ID:", id)
			$MultiplayerSpawner.spawn(id)
		)

		server.peer_disconnected.connect(func(id):
			print("Client disconnected with ID:", id)
		)
