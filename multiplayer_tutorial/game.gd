class_name Game
extends Node

@onready var multiplayer_ui = $UI/Multiplayer

const PLAYER = preload("res://player/player.tscn")

# var peer = ENetMultiplayerPeer.new()

var players: Array[Player] = []

func _ready() -> void:
	$MultiplayerSpawner.spawn_function = add_player
	if OS.has_feature("dedicated_server"):
		_on_host_pressed()

func _on_host_pressed() -> void:
	# peer.create_server(25565)
	# multiplayer.multiplayer_peer = peer
	# multiplayer.peer_connected.connect(
	# 	func(pid):
	# 		print("Peer " + str(pid) + " connected")
	# 		$MultiplayerSpawner.spawn(pid)
	# )
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

	# $MultiplayerSpawner.spawn(multiplayer.get_unique_id())
	multiplayer_ui.hide()

func _on_join_pressed() -> void:
	# peer.create_client("localhost", 25565)
	# multiplayer.multiplayer_peer = peer

	var client := WebSocketMultiplayerPeer.new()
	var url := "wss://www.sins621.com:5000"

	var result := client.create_client(url)
	if result != OK:
		print("Failed to connect to server:", result)
		return

	multiplayer.multiplayer_peer = client

	await multiplayer.connected_to_server
	multiplayer_ui.hide()
	print("Successfully connected to server")

func add_player(pid):
	var player = PLAYER.instantiate()
	player.name = str(pid)
	player.global_position = get_random_spawnpoint()
	players.append(player)
	return player

func get_random_spawnpoint():
	return $Level.get_children().pick_random().global_position
