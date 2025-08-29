extends Node3D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	update_minimap()

func update_minimap() -> void:
	var drone_pos = %TourismDrone.global_position
	drone_pos = drone_pos * (2560.0 / 1081.0)
	%MiniMap.texture.region.position.x = drone_pos.x - 200
	%MiniMap.texture.region.position.y = drone_pos.z - 200

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("quit"):
		get_tree().quit()
