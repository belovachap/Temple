extends Node3D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	update_minimap()
	update_follow_camera()

func update_minimap() -> void:
	var drone_pos = %TourismDrone.global_position
	drone_pos = drone_pos * (2560.0 / 1081.0)
	%MiniMap.texture.region.position.x = drone_pos.x - 200
	%MiniMap.texture.region.position.y = drone_pos.z - 200

func update_follow_camera() -> void:
	var boop = %TourismDrone.basis.x.normalized() * 10
	%FollowCamera3D.global_position.x = %TourismDrone.global_position.x - boop.x
	%FollowCamera3D.global_position.y = %TourismDrone.global_position.y + 10
	%FollowCamera3D.global_position.z = %TourismDrone.global_position.z - boop.z
	%FollowCamera3D.look_at(%TourismDrone.global_position)

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("switch_cameras"):
		if %FollowCamera3D.is_current():
			%FollowCamera3D.clear_current()
			%TourismDrone.get_node("%Camera3D").make_current()
		else:
			%TourismDrone.get_node("%Camera3D").clear_current()
			%FollowCamera3D.make_current()

	if event.is_action_pressed("quit"):
		get_tree().quit()
