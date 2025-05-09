extends Node2D

# Example: Load room ID from URL

func _ready() -> void:
	var room_id = JavaScriptBridge.eval("window.location.href")
	print(room_id)
	#JavaScriptBridge.eval("print('hello')")
