extends Node

const WEBSOCKET_URL = "ws://www.sins621.com/game/multiplayer_test"

var socket = WebSocketPeer.new()
var p1_pos = null
var p2_pos = null
@onready var player1: CharacterBody2D = $Player1
@onready var player2: CharacterBody2D = $Player2
@onready var ball: Area2D = $Ball

func _ready() -> void:
	Engine.max_fps = 60
	print("Attempting")
	var err = socket.connect_to_url(WEBSOCKET_URL)
	if err != OK:
		print("Unable to Connect")
		set_process(false)
	else:
		await get_tree().create_timer(2).timeout
		print("Connected")

func _process(delta: float) -> void:
	socket.poll()
	
	match socket.get_ready_state():
		WebSocketPeer.STATE_OPEN:
			while socket.get_available_packet_count():
				var raw = socket.get_packet().get_string_from_utf8()
				var data: Dictionary = JSON.parse_string(raw)
				if typeof(data) == TYPE_DICTIONARY && data.has("server"):
					player1.position.y = data["server"]["p1_pos"]
					player2.position.y = data["server"]["p2_pos"]
					ball.position = Vector2(data["server"]["ball_x"], data["server"]["ball_y"])
			var p1_dir = Input.get_action_strength("p1_down") - Input.get_action_strength("p1_up")
			var p2_dir = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
			
			var update = {
				"client": {
					"p1_y": p1_dir,
					"p2_y": p2_dir,
					"delta": delta
				}
			}
			socket.send_text(JSON.stringify(update))
		WebSocketPeer.STATE_CLOSING:
			pass
		WebSocketPeer.STATE_CLOSED:
			print("Disconnected")
			set_process(false)
