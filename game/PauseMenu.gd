extends Control

func _on_PauseButton_pressed():
	set_paused(true)

func _input(_event):
	if(Input.is_action_just_pressed("pause")):
		set_paused(not get_tree().paused)

func set_paused(p:bool):
	MusicManager.click()
	if(get_node("../End").visible):
		p = false
	get_tree().paused = p
	get_node("../PauseButton").visible = not p
	visible = p
	if(p):
		$Unpause.grab_focus()

func _on_Unpause_pressed():
	set_paused(false)

func _on_Reset_pressed():
	get_tree().paused = false
	MusicManager.click()
	get_tree().reload_current_scene()

func _on_MainMenu_pressed():
	get_tree().paused = false
	MusicManager.click()
	get_tree().change_scene("res://menus/MainMenu.tscn")
