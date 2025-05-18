class_name Game
extends Node

@onready var multiplayer_ui = $UI/Multiplayer
@onready var level := $Level

const PLAYER = preload("res://player/player.tscn")
const IDLE_TIMEOUT := 60  # seconds

var players: Array[Node] = []
var last_activity_time := {}

func _ready() -> void:
	$MultiplayerSpawner.spawn_function = add_player
	if OS.has_feature("dedicated_server"):
		_on_host_pressed()

func _on_host_pressed() -> void:
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
		despawn_player(id)
	)

	multiplayer_ui.hide()

func _on_join_pressed() -> void:
	var client := WebSocketMultiplayerPeer.new()
	var url := "wss://www.sins621.com/gamesocket/"

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
	add_child(player)

	last_activity_time[pid] = Time.get_unix_time_from_system()

	# OPTIONAL: If you want to track input per player
	player.connect("input_event", Callable(self, "_on_player_input").bind(pid))

	return player

func get_random_spawnpoint():
	return level.get_children().pick_random().global_position

func despawn_player(pid: int) -> void:
	var player_node := get_node_or_null(str(pid))
	if player_node:
		player_node.queue_free()
		players.erase(player_node)
	last_activity_time.erase(pid)

func _on_player_input(pid: int) -> void:
	last_activity_time[pid] = Time.get_unix_time_from_system()

func _process(_delta: float) -> void:
	var now = Time.get_unix_time_from_system()
	for pid in last_activity_time.keys():
		if now - last_activity_time[pid] > IDLE_TIMEOUT:
			print("Despawning idle player:", pid)
			despawn_player(pid)
