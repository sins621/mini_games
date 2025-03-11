extends Node2D

func _physics_process(_delta):
	detect_close()
	
func detect_close():
	if Input.is_key_pressed(KEY_ESCAPE):
		get_tree().quit()
