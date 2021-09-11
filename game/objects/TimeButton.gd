extends Area2D

export(float) var time_scale = 1
export(float) var min_spring_velocity = 300

signal set_time(button, t, v)
signal reset_time

func _on_TimeButton_body_entered(body):
	if(body.is_in_group("physics")):
		emit_signal("set_time", self, time_scale, max(abs(body.linear_velocity.y), min_spring_velocity))

func _on_TimeButton_body_exited(body):
	for b in get_overlapping_bodies():
		if(b.is_in_group("physics")):
			return # there is still another body inside, dont do anything
	emit_signal("reset_time")

func is_pressed():
	for b in get_overlapping_bodies():
		if(b.is_in_group("physics")):
			return true
	return false

func push_objects(velocity:float):
	for b in get_overlapping_bodies():
		if(b.is_in_group("physics")):
			b.linear_velocity.y -= velocity
