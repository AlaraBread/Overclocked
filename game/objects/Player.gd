extends RigidBody2D

export(float) var torque = 30
export(float) var brake_torque = 10
export(float) var jump_force = 200
export(float) var air_speed = 4

func _draw():
	pass
	#draw_circle(Vector2(), 30, Color(0.589844, 0.589844, 0.589844))
	#draw_line(Vector2(), Vector2(30, 0), Color(0.152344, 0.152344, 0.152344), 10)

func _physics_process(delta):
	if(Input.is_action_pressed("left")):
		angular_velocity -= delta*torque
	elif(Input.is_action_pressed("right")):
		angular_velocity += delta*torque
	else:
		angular_velocity -= angular_velocity*(brake_torque*delta)

func _process(delta):
	$AnimatedSprite.rotation = -rotation
	$AnimatedSprite.speed_scale = abs(angular_velocity*.2)

func _integrate_forces(state):
	if(state.get_contact_count() > 0):
		if(Input.is_action_just_pressed("jump")):
			var p_i = 0
			for i in range(state.get_contact_count()):
				if(state.get_contact_collider_object(i).is_in_group("physics")):
					p_i = i
					break
			state.linear_velocity += state.get_contact_local_normal(p_i)*jump_force
			var col = state.get_contact_collider_object(p_i)
			if(col.is_in_group("physics")):
				col.linear_velocity -= state.get_contact_local_normal(p_i)*jump_force
	else:
		if(Input.is_action_pressed("left")):
			state.linear_velocity.x -= air_speed
		elif(Input.is_action_pressed("right")):
			state.linear_velocity.x += air_speed
