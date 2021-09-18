extends Control

func _ready():
	$Back.grab_focus()

func _on_Back_pressed():
	get_tree().change_scene("res://menus/MainMenu.tscn")
