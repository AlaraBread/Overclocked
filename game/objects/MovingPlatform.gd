extends StaticBody2D

export(Vector2) var offset = Vector2(64, 0)
export(float) var speed:float = 1

var initial_pos:Vector2
var end_pos:Vector2
var dir:Vector2
func _ready():
	if(offset.x < 0):
		position.x += offset.x
		offset.x *= -1
	if(offset.y < 0):
		position.y += offset.y
		offset.y *= -1
	initial_pos = position
	end_pos = position+offset
	dir = offset.normalized()

func _physics_process(delta:float):
	position += dir*(speed*delta*time_scale)
	if((position-end_pos).length_squared() < 10):
		dir = -Vector2(abs(dir.x), abs(dir.y))
		constant_linear_velocity = dir*(speed*time_scale)
	elif((position-initial_pos).length_squared() < 10):
		dir = Vector2(abs(dir.x), abs(dir.y))
		constant_linear_velocity = dir*(speed*time_scale)

var time_scale:float = 1
func time_scale_changed(t:float):
	time_scale = t
	constant_linear_velocity = dir*(speed*t)
