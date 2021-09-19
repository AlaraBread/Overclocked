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
	$Player.set_camera_limit($CamLowerLimit.position, $CamUpperLimit.position)
	connect("time_scale_changed", $ParallaxBackground/Clock, "time_scale_changed")
	for c in $MovingPlatforms.get_children():
		connect("time_scale_changed", c, "time_scale_changed")
		for b in c.get_children():
			if(b.is_in_group("time button")):
				setup_time_button(b)
	set_time(default_time)
	for c in $TimeButtons.get_children():
		setup_time_button(c)
	for t in $TileMap.get_used_cells():
		match $TileMap.get_cellv(t):
			26,25: # if this cell is lava
				#only add the lava entity if this tile isnt the top layer
				if($TileMap.get_cell_autotile_coord(t.x, t.y) != Vector2()):
					#add a lava entity here
					var lava = preload("res://game/objects/Lava.tscn").instance()
					lava.position = t*64+Vector2(32, 32)
					add_child(lava)
			6: # this cell is the clockwise conveyor autotile
				var offset = $TileMap.get_cell_autotile_coord(t.x, t.y).x
				$TileMap.set_cellv(t, -1) # delete the tile
				var c = preload("res://game/objects/ConveyorBelt.tscn").instance()
				c.position = t*64+Vector2(32, 32)
				c.set_tile(offset)
				c.velocity = Vector2.RIGHT*50
				connect("time_scale_changed", c, "time_scale_changed")
				add_child(c)
			10: # this cell is the anti clockwise conveyor autotile
				var offset = $TileMap.get_cell_autotile_coord(t.x, t.y).x
				$TileMap.set_cellv(t, -1) # delete the tile
				var c = preload("res://game/objects/ConveyorBelt.tscn").instance()
				c.position = t*64+Vector2(32, 32)
				c.set_tile(offset)
				c.velocity = Vector2.LEFT*50
				connect("time_scale_changed", c, "time_scale_changed")
				add_child(c)
			

func time_button_pressed(button:Node, t:float, v:float):
	for b in time_buttons:
		if(b != button):
			b.push_objects(v)
	set_time(t)

func reset_time():
	for b in time_buttons:
		if(b.is_pressed()):
			return # a button is pressed, dont do anything
	set_time(default_time)

func _on_ExitDoor_entered():
	Engine.time_scale = 0.5
	$CanvasLayer/End.visible = true
	$CanvasLayer/End/NextLevel.grab_focus()

var target_time:float = 0
var start_time:float = 0
var time_scale:float = 0
func set_time(t:float):
	time_timer = 0
	target_time = t
	start_time = time_scale
	set_process(true)

var time_timer:float = 0
const time_seconds:float = 1.0
func _process(delta):
	time_timer = clamp(time_timer+(delta/time_seconds), 0, 1)
	time_scale = lerp(start_time, target_time, time_timer)
	emit_signal("time_scale_changed", time_scale)
	if(time_timer == 1):
		set_process(false)

func _on_NextLevel_pressed():
	Engine.time_scale = 1
	MusicManager.click()
	get_tree().change_scene("res://game/levels/Level"+str(level_number+1)+".tscn")
