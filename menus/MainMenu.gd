extends Node2D

func _on_Play_pressed():
	get_tree().change_scene("res://game/levels/Level1.tscn")

func _on_Settings_pressed():
	get_tree().change_scene("res://menus/Settings.tscn")

var start_pos:Vector2
func _ready():
	start_pos = $Camera2D.position
	var s = preload("res://menus/Settings.tscn").instance()
	add_child(s)
	s.queue_free()
	$ParallaxBackground/Title/Play.grab_focus()

var started:bool = false
func _on_StartTimer_timeout():
	started = true

var moved:bool = false
func _input(event):
	if(not started):
		return
	if(event is InputEventMouseMotion):
		$Camera2D.position += event.relative*10
		$Camera2D.position = lerp($Camera2D.position, start_pos, 0.5)
		moved = true

func _process(delta):
	if(not moved):
		$Camera2D.position = lerp($Camera2D.position, start_pos, clamp(delta*5, 0, 1))
	moved = false

func _on_Quit_pressed():
	get_tree().quit()
