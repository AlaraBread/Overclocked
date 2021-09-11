extends Node2D

export(float) var default_time = 1

signal time_scale_changed(t)
func _ready():
	for c in $MovingPlatforms.get_children():
		connect("time_scale_changed", c, "time_scale_changed")
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
