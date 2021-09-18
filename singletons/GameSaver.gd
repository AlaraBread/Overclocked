extends Node

var level_code:String
var error:String

func get_filename():
	return "user://save.json"

signal setup
var setup_done:bool = false
var data = {}
func _ready():
	randomize()
	var f = File.new()
	var e = f.open(get_filename(), File.READ)
	if(e != OK):
		setup()
		return
	var s = f.get_as_text()
	f.close()
	var result = JSON.parse(s)
	if(result.error != OK):
		setup()
		return
	data = result.result
	setup()
	setup_done = true
	emit_signal("setup")

var defaults = [
]
func setup():
	for i in defaults:
		if(get(i[0]) == null):
			set(i[0], i[1])

func save():
	var s = JSON.print(data)
	var f = File.new()
	f.open(get_filename(), File.WRITE)
	f.store_string(s)
	f.close()

func set(key, value):
	data[key] = value

func get(key):
	if(data.has(key)):
		return data[key]
	return null

func reset():
	setup()

func _exit_tree():
	save()
