extends Area2D

export(float) var time_scale = 1
export(float) var min_spring_velocity = 300

signal set_time(button, t, v)
signal reset_time

func _ready():
	if(time_scale < 0):
		$AnimatedSprite.frames = preload("res://game/objects/TimeButton2.tres")
	else:
		$AnimatedSprite.frames = preload("res://game/objects/TimeButton1.tres")

func _on_TimeButton_body_entered(body):
	if(body.is_in_group("physics")):
		emit_signal("set_time", self, time_scale, max(abs(body.linear_velocity.y), min_spring_velocity))
		$AnimatedSprite.play("pressed")

func _on_TimeButton_body_exited(_body):
	for b in get_overlapping_bodies():
		if(b.is_in_group("physics")):
			return # there is still another body inside, dont do anything
	emit_signal("reset_time")
	if($AnimatedSprite.animation != "spring"):
		$AnimatedSprite.play("default")

func is_pressed():
	for b in get_overlapping_bodies():
		if(b.is_in_group("physics")):
			return true
	return false

func push_objects(velocity:float):
	var c:int = 0
	for b in get_overlapping_bodies():
		if(b.is_in_group("physics")):
			c += 1
			b.linear_velocity.y -= velocity
	if(c > 0):
		$AnimatedSprite.play("spring")

func _on_AnimatedSprite_animation_finished():
	if($AnimatedSprite.animation == "spring"):
		$AnimatedSprite.play("default")
