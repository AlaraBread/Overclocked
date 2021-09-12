extends Node2D

export(int) var level_number = 0
export(float) var default_time = 0

signal time_scale_changed(t)
func _ready():
	for c in $MovingPlatforms.get_children():
		connect("time_scale_changed", c, "time_scale_changed")
	emit_signal("time_scale_changed", default_time)
	for c in $TimeButtons.get_children():
		c.connect("set_time", self, "time_button_pressed")
		c.connect("reset_time", self, "reset_time")

func time_button_pressed(button:Node, t:float, v:float):
	for b in $TimeButtons.get_children():
		if(b != button):
			b.push_objects(v)
	emit_signal("time_scale_changed", t)

func reset_time():
	for b in $TimeButtons.get_children():
		if(b.is_pressed()):
			return # a button is pressed, dont do anything
	emit_signal("time_scale_changed", default_time)

func _on_ExitDoor_entered():
	get_tree().paused = true
	$CanvasLayer/End.visible = true

func _on_NextLevel_pressed():
	get_tree().paused = false
	get_tree().change_scene("res://game/levels/Level"+str(level_number+1)+".tscn")
