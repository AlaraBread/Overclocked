extends RigidBody2D

var start_pos:Vector2
func _ready():
	start_pos = position

var should_reset:bool = false
func reset():#should put the object back where it was at the start
	should_reset = true

func _integrate_forces(state):
	if(should_reset):
		state.transform = state.transform.rotated(-state.transform.get_rotation())
		state.transform.origin = start_pos
		state.linear_velocity = Vector2()
		state.angular_velocity = 0
		should_reset = false
