extends Node2D

# Config
const GAME_ID := "test-room"
const MAX_PLAYERS := 2

# Role management
var is_server := false
var peer: MultiplayerPeer
var client_role := ""  # "player1" or "player2"
var positions := {
	"player1": Vector2(100, 100),
	"player2": Vector2(400, 100),
}

@onready var player1 = $Player1
@onready var player2 = $Player2

func _ready():
	var args = OS.get_cmdline_args()
	var mode = "client"

	if "--server" in args:
		mode = "server"

	is_server = (mode == "server")

	if is_server:
		_start_server()
	else:
		_start_client()

	set_process(true)


# ───────────────────────────────────────────────
# SERVER SETUP
# ───────────────────────────────────────────────
func _start_server():
	var server_peer := WebSocketMultiplayerPeer.new()
	var result = server_peer.create_server(8080)
	if result != OK:
		push_error("Server failed to start")
		return

	multiplayer.multiplayer_peer = server_peer
	print("Server running...")

	# Dict of game_id -> client_id -> peer_id
	var games := {}

	multiplayer.peer_connected.connect(func(id):
		print("Client connected:", id)
	)

	multiplayer.peer_disconnected.connect(func(id):
		print("Client disconnected:", id)
		for game_id in games:
			for cid in games[game_id]:
				if games[game_id][cid] == id:
					games[game_id].erase(cid)

	)

	multiplayer.data_received.connect(func():
		var from_id = multiplayer.get_packet_peer()
		var data = multiplayer.get_packet().get_string_from_utf8()
		var msg = JSON.parse_string(data)
		if typeof(msg) != TYPE_DICTIONARY:
			return

		var game_id = msg.get("game_id", null)
		if game_id == null:
			return

		if not games.has(game_id):
			games[game_id] = {}

		var game = games[game_id]

		# Assign a role if not already assigned
		if not game.values().has(from_id):
			if not game.has("player1"):
				game["player1"] = from_id
				_send_role(from_id, "player1", game_id)
			elif not game.has("player2"):
				game["player2"] = from_id
				_send_role(from_id, "player2", game_id)
			else:
				multiplayer.send_bytes(from_id, JSON.stringify({ "error": "Game full" }).to_utf8_buffer())
				return

		# Broadcast positions
		if msg.has("position") and msg.has("client_id"):
			for other_id in game.values():
				if other_id != from_id:
					multiplayer.send_bytes(other_id, data.to_utf8_buffer())

	)

func _send_role(peer_id: int, role: String, game_id: String):
	var msg = {
		"game_id": game_id,
		"assigned_role": role
	}
	multiplayer.send_bytes(peer_id, JSON.stringify(msg).to_utf8_buffer())
	print("Assigned", role, "to peer", peer_id)

# ───────────────────────────────────────────────
# CLIENT SETUP
# ───────────────────────────────────────────────
func _start_client():
	var client_peer := WebSocketMultiplayerPeer.new()
	var connected := false

	while not connected:
		var result = client_peer.create_client("ws://localhost:8080")
		if result == OK:
			multiplayer.multiplayer_peer = client_peer
			multiplayer.connected_to_server.connect(_on_connected)
			multiplayer.data_received.connect(_on_data_received)
			connected = true
			print("Connected to server")
		else:
			print("Server not ready. Retrying in 1s...")
			await get_tree().create_timer(1.0).timeout


func _on_connected():
	print("Connected to server")
	var msg = {
		"game_id": GAME_ID
	}
	multiplayer.send_bytes(1, JSON.stringify(msg).to_utf8_buffer())

func _on_data_received():
	var _peer_id = multiplayer.get_packet_peer()
	var data = multiplayer.get_packet().get_string_from_utf8()
	var msg = JSON.parse_string(data)

	if typeof(msg) != TYPE_DICTIONARY:
		return

	if msg.has("assigned_role"):
		client_role = msg["assigned_role"]
		print("I am", client_role)

	if msg.has("client_id") and msg.has("position"):
		var cid = msg["client_id"]
		if positions.has(cid):
			var pos = msg["position"]
			positions[cid] = Vector2(pos["x"], pos["y"])

# ───────────────────────────────────────────────
# MOVEMENT + RENDER
# ───────────────────────────────────────────────
func _process(delta):
	if is_server or client_role == "":
		return

	var move = Vector2.ZERO
	move.x += Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	move.y += Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")

	if move != Vector2.ZERO:
		positions[client_role] += move.normalized() * 100 * delta
		var msg = {
			"game_id": GAME_ID,
			"client_id": client_role,
			"position": positions[client_role]
		}
		multiplayer.send_bytes(1, JSON.stringify(msg).to_utf8_buffer())

	player1.position = positions["player1"]
	player2.position = positions["player2"]
