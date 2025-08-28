extends Node3D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var drone_pos = %TourismDrone.global_position
	drone_pos = drone_pos * (2560.0 / 4096.0)
	%MiniMap.texture.region.position.x = drone_pos.x - 200
	%MiniMap.texture.region.position.y = drone_pos.z - 200
