extends Control

func _ready():
	$Back.grab_focus()

func _on_Back_pressed():
	MusicManager.click()
	get_tree().change_scene("res://menus/MainMenu.tscn")
