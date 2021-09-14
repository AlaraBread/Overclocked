extends Node2D

export(int) var level_number = 0
export(float) var default_time = 0

signal time_scale_changed(t)

var time_buttons = []
func setup_time_button(b):
	time_buttons.append(b)
	b.connect("set_time", self, "time_button_pressed")
	b.connect("reset_time", self, "reset_time")

func _ready():
	for c in $MovingPlatforms.get_children():
		connect("time_scale_changed", c, "time_scale_changed")
		for b in c.get_children():
			if(b.is_in_group("time button")):
				setup_time_button(b)
	emit_signal("time_scale_changed", default_time)
	for c in $TimeButtons.get_children():
		setup_time_button(c)
	for t in $TileMap.get_used_cells():
		if($TileMap.get_cellv(t) == 5): # if this cell is lava
			$TileMap.set_cellv(t, -1) # delete the lava tile
			#add a lava entity there
			var lava = preload("res://game/objects/Lava.tscn").instance()
			lava.position = t*64+Vector2(32, 32)
			add_child(lava)

func time_button_pressed(button:Node, t:float, v:float):
	for b in time_buttons:
		if(b != button):
			b.push_objects(v)
	emit_signal("time_scale_changed", t)

func reset_time():
	for b in time_buttons:
		if(b.is_pressed()):
			return # a button is pressed, dont do anything
	emit_signal("time_scale_changed", default_time)

func _on_ExitDoor_entered():
	get_tree().paused = true
	$CanvasLayer/End.visible = true

func _on_NextLevel_pressed():
	get_tree().paused = false
	get_tree().change_scene("res://game/levels/Level"+str(level_number+1)+".tscn")
