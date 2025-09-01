extends RigidBody3D

func _physics_process(delta: float) -> void:
	apply_force(Vector3(0, 3, 0), %Engine1.position)
	apply_force(Vector3(0, 3, 0), %Engine2.position)
	apply_force(Vector3(0, 3, 0), %Engine3.position)
	apply_force(Vector3(0, 3, 0), %Engine4.position)
