extends RigidBody3D

const MAX_ENGINE_POWER = 1.0
const MIN_ENGINE_POWER = 0.0
const POWER_ADJUSTMENT_Y_PER_SECOND = 1
const POWER_ADJUSTMENT_X_PER_SECOND = 1

var engine1_power = MAX_ENGINE_POWER / 2.0
var engine2_power = MAX_ENGINE_POWER / 2.0
var engine3_power = MAX_ENGINE_POWER / 2.0
var engine4_power = MAX_ENGINE_POWER / 2.0

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
		desired_x_velocity = 1.0
	elif Input.is_action_pressed("drone_backward"):
		desired_x_velocity = -1.0
	else:
		desired_x_velocity = 0.0

func _physics_process(delta: float) -> void:
	y_pos_before = y_pos_now
	y_pos_now = global_position.y
	y_velocity = (y_pos_now - y_pos_before) / delta

	x_pos_before = x_pos_now
	x_pos_now = global_position.x
	x_velocity = (x_pos_now - x_pos_before) / delta

	if y_velocity > desired_y_velocity:
		engine1_power -= POWER_ADJUSTMENT_Y_PER_SECOND * delta
		engine2_power -= POWER_ADJUSTMENT_Y_PER_SECOND * delta
		engine3_power -= POWER_ADJUSTMENT_Y_PER_SECOND * delta
		engine4_power -= POWER_ADJUSTMENT_Y_PER_SECOND * delta
	else:
		engine1_power += POWER_ADJUSTMENT_Y_PER_SECOND * delta
		engine2_power += POWER_ADJUSTMENT_Y_PER_SECOND * delta
		engine3_power += POWER_ADJUSTMENT_Y_PER_SECOND * delta
		engine4_power += POWER_ADJUSTMENT_Y_PER_SECOND * delta

	#if x_velocity > desired_x_velocity:
		#engine1_power += POWER_ADJUSTMENT_X_PER_SECOND * delta
		#engine2_power += POWER_ADJUSTMENT_X_PER_SECOND * delta
		#engine3_power -= POWER_ADJUSTMENT_X_PER_SECOND * delta
		#engine4_power -= POWER_ADJUSTMENT_X_PER_SECOND * delta
	#else:
		#engine1_power -= POWER_ADJUSTMENT_X_PER_SECOND * delta
		#engine2_power -= POWER_ADJUSTMENT_X_PER_SECOND * delta
		#engine3_power += POWER_ADJUSTMENT_X_PER_SECOND * delta
		#engine4_power += POWER_ADJUSTMENT_X_PER_SECOND * delta

	engine1_power = clampf(engine1_power, MIN_ENGINE_POWER, MAX_ENGINE_POWER)
	engine2_power = clampf(engine2_power, MIN_ENGINE_POWER, MAX_ENGINE_POWER)
	engine3_power = clampf(engine3_power, MIN_ENGINE_POWER, MAX_ENGINE_POWER)
	engine4_power = clampf(engine4_power, MIN_ENGINE_POWER, MAX_ENGINE_POWER)

	var engine1_y_basis = %Engine1.global_transform.basis.orthonormalized().y
	var engine2_y_basis = %Engine2.global_transform.basis.orthonormalized().y
	var engine3_y_basis = %Engine3.global_transform.basis.orthonormalized().y
	var engine4_y_basis = %Engine4.global_transform.basis.orthonormalized().y
	
	apply_force(engine1_y_basis * engine1_power, %Engine1.position)
	apply_force(engine2_y_basis * engine2_power, %Engine2.position)
	apply_force(engine3_y_basis * engine3_power, %Engine3.position)
	apply_force(engine4_y_basis * engine4_power, %Engine4.position)

func _on_debug_timer_timeout() -> void:
	print("Position: ", global_position)
	print("Y Velocity: ", y_velocity)
	print("X Velocity: ", x_velocity)
	print("Engine 1 Power: ", engine1_power)
	print("Engine 2 Power: ", engine2_power)
	print("Engine 3 Power: ", engine3_power)
	print("Engine 4 Power: ", engine4_power)
