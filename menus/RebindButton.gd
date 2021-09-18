extends Button

# Set this string to the name of the action in the InputMap
export(String) var action

func _ready():
	$Label.text = action+"  "
	$Label.text[0] = $Label.text[0].to_upper()
	if(GameSaver.get(action) != null):
		pressed = true
		_input(event_from_dict(GameSaver.get(action)))
	_update_button_text(InputMap.get_action_list(action)[0])

func _input(input_event: InputEvent) -> void:
	if pressed and not input_event is InputEventMouseMotion:
		if not input_event.is_pressed():
			pressed = false
			release_focus()
			InputMap.action_erase_events(action)
			InputMap.action_add_event(action, input_event)
			_update_button_text(input_event)
			grab_focus()
			
			GameSaver.set(action, event_to_dict(input_event))

func _update_button_text(input_event: InputEvent) -> void:
	if input_event is InputEventMouseButton:
			if input_event.button_index == BUTTON_LEFT:
				text = "Mouse Left"
			elif input_event.button_index == BUTTON_RIGHT:
				text = "Mouse Right"
			elif input_event.button_index == BUTTON_MIDDLE:
				text = "Mouse Middle"
	else:
		text = input_event.as_text()

func _on_RebindButton_toggled(button_pressed):
	if(button_pressed):
		text = "Press a button..."

func event_to_dict(e):
	if(e is InputEventKey):
		return {"type":"key", "scancode":e.get_scancode()}
	if(e is InputEventMouseButton):
		return {"type":"mouse button", "index":e.button_index}

func event_from_dict(d):
	if(d["type"] == "key"):
		var e = InputEventKey.new()
		e.set_scancode(d["scancode"])
		return e
	if(d["type"] == "mouse button"):
		var e = InputEventMouseButton.new()
		e.set_button_index(d["index"])
		return e
