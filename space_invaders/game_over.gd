extends CanvasLayer

func _on_restart_button_pressed():
	print("Pressing Restart Button")
	get_tree().change_scene_to_file("res://main.tscn")
