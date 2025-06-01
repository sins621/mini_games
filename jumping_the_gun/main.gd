extends Node


func _ready():
	pass

func _process(_delta):
	if Input.is_action_pressed("escape"):
		get_tree().quit()