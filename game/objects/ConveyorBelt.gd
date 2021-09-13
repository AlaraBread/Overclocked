extends StaticBody2D

export(Vector2) var velocity = Vector2.RIGHT

func time_scale_changed(t:float):
	constant_linear_velocity = velocity*t
