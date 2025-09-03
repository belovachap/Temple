extends RigidBody3D

const MAX_ENGINE_POWER = 0.8
const MIN_ENGINE_POWER = 0.0
const POWER_ADJUSTMENT_Y_PER_SECOND = MAX_ENGINE_POWER * 10
const POWER_ADJUSTMENT_X_PER_SECOND = MAX_ENGINE_POWER * 10

var engine1_power = MAX_ENGINE_POWER
var engine2_power = MAX_ENGINE_POWER
var engine3_power = MAX_ENGINE_POWER
var engine4_power = MAX_ENGINE_POWER

var desired_y_velocity = 0.0
var y_pos_before
var y_pos_now
var y_velocity

var desired_x_velocity = 0.0
var x_pos_before
var x_pos_now
var x_velocity

func _ready() -> void:
	y_pos_now = global_position.y
	x_pos_now = global_position.x

func _process(delta: float) -> void:
	if Input.is_action_pressed("drone_ascend"):
		desired_y_velocity = 1.0
	elif Input.is_action_pressed("drone_descend"):
		desired_y_velocity = -1.0
	else:
		desired_y_velocity = 0.0

	if Input.is_action_pressed("drone_forward"):
		desired_x_velocity = 0.1
	elif Input.is_action_pressed("drone_backward"):
		desired_x_velocity = -0.1
	else:
		desired_x_velocity = 0.0

func _physics_process(delta: float) -> void:
	y_pos_before = y_pos_now
	y_pos_now = global_position.y
	y_velocity = (y_pos_now - y_pos_before) / delta

	x_pos_before = x_pos_now
	x_pos_now = global_position.x
	x_velocity = (x_pos_now - x_pos_before) / delta

	var euler = global_transform.basis.get_euler() # radians
	var roll_deg = rad_to_deg(euler.x)
	var yaw_deg = rad_to_deg(euler.y)
	var pitch_deg = rad_to_deg(euler.z)

	if y_velocity < desired_y_velocity:
		engine1_power += POWER_ADJUSTMENT_Y_PER_SECOND * delta
		engine2_power += POWER_ADJUSTMENT_Y_PER_SECOND * delta
		engine3_power += POWER_ADJUSTMENT_Y_PER_SECOND * delta
		engine4_power += POWER_ADJUSTMENT_Y_PER_SECOND * delta
	else:
		engine1_power -= POWER_ADJUSTMENT_Y_PER_SECOND * delta
		engine2_power -= POWER_ADJUSTMENT_Y_PER_SECOND * delta
		engine3_power -= POWER_ADJUSTMENT_Y_PER_SECOND * delta
		engine4_power -= POWER_ADJUSTMENT_Y_PER_SECOND * delta

	engine1_power = clampf(engine1_power, MIN_ENGINE_POWER, MAX_ENGINE_POWER)
	engine2_power = clampf(engine2_power, MIN_ENGINE_POWER, MAX_ENGINE_POWER)
	engine3_power = clampf(engine3_power, MIN_ENGINE_POWER, MAX_ENGINE_POWER)
	engine4_power = clampf(engine4_power, MIN_ENGINE_POWER, MAX_ENGINE_POWER)

	var engine1_adjusted = engine1_power
	var engine2_adjusted = engine2_power
	var engine3_adjusted = engine3_power
	var engine4_adjusted = engine4_power

	
	const PITCH_ADJUSTMENT = 0.001
	if desired_x_velocity > 0:
		if pitch_deg > -0.05:
			engine1_adjusted -= PITCH_ADJUSTMENT
			engine2_adjusted -= PITCH_ADJUSTMENT
			engine3_adjusted += PITCH_ADJUSTMENT
			engine4_adjusted += PITCH_ADJUSTMENT
	elif desired_x_velocity < 0:
		if pitch_deg < 0.05:
			engine1_adjusted += PITCH_ADJUSTMENT * 2
			engine2_adjusted += PITCH_ADJUSTMENT * 2
			engine3_adjusted -= PITCH_ADJUSTMENT * 2
			engine4_adjusted -= PITCH_ADJUSTMENT * 2
	else:
		if pitch_deg > 0:
			engine1_adjusted -= PITCH_ADJUSTMENT * 2
			engine2_adjusted -= PITCH_ADJUSTMENT * 2
			engine3_adjusted += PITCH_ADJUSTMENT * 2
			engine4_adjusted += PITCH_ADJUSTMENT * 2
		else:
			engine1_adjusted += PITCH_ADJUSTMENT * 2
			engine2_adjusted += PITCH_ADJUSTMENT * 2
			engine3_adjusted -= PITCH_ADJUSTMENT * 2
			engine4_adjusted -= PITCH_ADJUSTMENT * 2

	engine1_adjusted = clampf(engine1_adjusted, MIN_ENGINE_POWER, MAX_ENGINE_POWER)
	engine2_adjusted = clampf(engine2_adjusted, MIN_ENGINE_POWER, MAX_ENGINE_POWER)
	engine3_adjusted = clampf(engine3_adjusted, MIN_ENGINE_POWER, MAX_ENGINE_POWER)
	engine4_adjusted = clampf(engine4_adjusted, MIN_ENGINE_POWER, MAX_ENGINE_POWER)

	var engine1_y_basis = %Engine1.global_transform.basis.orthonormalized().y
	var engine2_y_basis = %Engine2.global_transform.basis.orthonormalized().y
	var engine3_y_basis = %Engine3.global_transform.basis.orthonormalized().y
	var engine4_y_basis = %Engine4.global_transform.basis.orthonormalized().y
	
	apply_force(engine1_y_basis * engine1_adjusted, %Engine1.position)
	apply_force(engine2_y_basis * engine2_adjusted, %Engine2.position)
	apply_force(engine3_y_basis * engine3_adjusted, %Engine3.position)
	apply_force(engine4_y_basis * engine4_adjusted, %Engine4.position)

func _on_debug_timer_timeout() -> void:
	print("Position: ", global_position)
	print("Y Velocity: ", y_velocity)
	print("X Velocity: ", x_velocity)
	print("Engine 1 Power: ", engine1_power)
	print("Engine 2 Power: ", engine2_power)
	print("Engine 3 Power: ", engine3_power)
	print("Engine 4 Power: ", engine4_power)
	
	var euler = global_transform.basis.get_euler() # radians
	var roll_deg = rad_to_deg(euler.x)
	var yaw_deg = rad_to_deg(euler.y)
	var pitch_deg = rad_to_deg(euler.z)
	print("roll_deg: ", roll_deg)
	print("yaw_deg: ", yaw_deg)
	print("pitch_deg: ", pitch_deg)
