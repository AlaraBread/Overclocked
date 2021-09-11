extends StaticBody2D

export(float) var spin_speed = 1
func _physics_process(delta):
	rotation += spin_speed*time_scale*delta

var time_scale:float = 1
func time_scale_changed(t:float):
	time_scale = t
	constant_angular_velocity = spin_speed*t
