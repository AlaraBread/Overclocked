extends HSlider
tool

export(String) var save_name:String = ""
export(String) var bus_name:String = ""
export(String) var label_text:String = "" setget set_label_text

func set_label_text(new:String):
	label_text = new
	$Label.text = new+"     "

func _ready():
	if(Engine.editor_hint):
		return
	$Label.text = label_text
	value = GameSaver.get(save_name)

func _on_AudioSlider_value_changed(value):
	if(Engine.editor_hint):
		return
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index(bus_name), linear2db(value))
	GameSaver.set(save_name, value)
