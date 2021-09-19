extends Control

func _input(event):
	if(event is InputEventKey and event.is_pressed()):
		MusicManager.click()
		get_tree().change_scene("res://menus/MainMenu.tscn")
