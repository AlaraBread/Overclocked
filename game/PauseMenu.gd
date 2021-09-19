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
		MusicManager.vol(0.25)
		$Unpause.grab_focus()
	else:
		MusicManager.vol(1)

func _on_Unpause_pressed():
	set_paused(false)

func _on_Reset_pressed():
	get_tree().paused = false
	MusicManager.click()
	MusicManager.vol(1)
	get_tree().reload_current_scene()

func _on_MainMenu_pressed():
	get_tree().paused = false
	MusicManager.click()
	MusicManager.vol(1)
	get_tree().change_scene("res://menus/MainMenu.tscn")
