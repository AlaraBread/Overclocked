extends RigidBody2D

export(float) var zoom = 1.5
export(float) var torque = 30
export(float) var brake_torque = 10
export(float) var jump_force = 200
export(float) var air_speed = 4

const faces = [preload("res://assets/player/sprocketeyeup.png"),
		preload("res://assets/player/sprocketeyedown.png"),
		preload("res://assets/player/sprocketeyeleft.png"),
		preload("res://assets/player/sprocketeyeright.png"),
		preload("res://assets/player/sprocketface.png")]

var start_pos:Vector2
func _ready():
	$Camera2D.zoom = Vector2(zoom, zoom)
	start_pos = position

func set_camera_limit(low:Vector2, high:Vector2):
	$Camera2D.limit_left = low.x
	$Camera2D.limit_top = low.y
	$Camera2D.limit_right = high.x
	$Camera2D.limit_bottom = high.y

func _physics_process(delta):
	if(Input.is_action_pressed("left")):
		angular_velocity -= delta*torque
	elif(Input.is_action_pressed("right")):
		angular_velocity += delta*torque
	else:
		angular_velocity -= angular_velocity*(brake_torque*delta)

#holds the object to be jumped off of and the normal of our collision
var jump_info:Array = [null, Vector2()]

var should_reset:bool = false
func reset():
	should_reset = true

func _integrate_forces(state):
	if(not active):
		return
	if(Input.is_action_just_pressed("jump") and can_jump and jump_info[0] != null):
		can_jump = false
		state.linear_velocity += jump_info[1]*jump_force
		var col = jump_info[0]
		if(col.is_in_group("physics")):
			col.linear_velocity -= jump_info[1]*jump_force
	if(should_reset):
		should_reset = false
		state.transform = state.transform.rotated(-state.transform.get_rotation())
		state.transform.origin = start_pos
		state.linear_velocity = Vector2()
		state.angular_velocity = 0
	if(state.get_contact_count() > 0):
		var p_i = 0
		for i in range(state.get_contact_count()):
			if(state.get_contact_collider_object(i).is_in_group("physics")):
				p_i = i
				break
		jump_info = [state.get_contact_collider_object(p_i), state.get_contact_local_normal(p_i)]
		can_jump = true
		$GroundCooldown.start()
	else:
		if(Input.is_action_pressed("left")):
			state.linear_velocity.x -= air_speed
		elif(Input.is_action_pressed("right")):
			state.linear_velocity.x += air_speed

func _process(_delta):
	#face animation
	$Face.rotation = -rotation+linear_velocity.x*0.001
	var dir = linear_velocity.normalized()
	if(linear_velocity.length() < 50):
		$Face.texture = faces[4]
	elif((dir.dot(Vector2.UP)) > 0.25):
		$Face.texture = faces[0]
	elif((dir.dot(Vector2.DOWN)) > 0.25):
		$Face.texture = faces[1]
	elif((dir.dot(Vector2.LEFT)) > 0.25):
		$Face.texture = faces[2]
	elif((dir.dot(Vector2.RIGHT)) > 0.25):
		$Face.texture = faces[3]

var can_jump:bool = false
func _on_GroundCooldown_timeout():
	can_jump = false

var active:bool = true
func dummy_mode():
	active = false
	collision_layer = 0
	collision_mask = 0
