extends CharacterBody3D

const MAX_VELOCITY = 10.0 # m/s
const ACCELERATION = MAX_VELOCITY # m/s^2

const MAX_ROTATION = PI / 8 # degrees/s
const ANGULAR_ACCELERATION = MAX_ROTATION # degrees/s^2

func _physics_process(delta: float) -> void:
	if Input.is_action_pressed("drone_ascend"):
		velocity.y += ACCELERATION * delta
	elif Input.is_action_pressed("drone_descend"):
		velocity.y -= ACCELERATION * delta
	else:
		if velocity.y > 0.0:
			velocity.y -= ACCELERATION * delta
		elif velocity.y < 0.0:
			velocity.y += ACCELERATION * delta

	if Input.is_action_pressed("drone_forward"):
		velocity += basis.x * ACCELERATION * delta
	elif Input.is_action_pressed("drone_backward"):
		velocity -= basis.x * ACCELERATION * delta
	else:
		if basis.x.dot(velocity) > 0.1:
			velocity -= basis.x * ACCELERATION * delta
		elif basis.x.dot(velocity) < 0.0:
			velocity += basis.x * ACCELERATION * delta

	if Input.is_action_pressed("drone_roll_left"):
		velocity -= basis.z * ACCELERATION * delta
	elif Input.is_action_pressed("drone_roll_right"):
		velocity += basis.z * ACCELERATION * delta
	else:
		if basis.z.dot(velocity) > 0.0:
			velocity -= basis.z * ACCELERATION * delta
		elif basis.z.dot(velocity) < 0.0:
			velocity += basis.z * ACCELERATION * delta

	if Input.is_action_pressed("drone_rotate_left"):
		rotate(Vector3(0.0, 1.0, 0.0), ANGULAR_ACCELERATION * delta)
	elif Input.is_action_pressed("drone_rotate_right"):
		rotate(Vector3(0.0, 1.0, 0.0), -ANGULAR_ACCELERATION * delta)

	velocity = velocity.limit_length(MAX_VELOCITY)

	move_and_slide()
