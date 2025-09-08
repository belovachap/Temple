extends MarginContainer

func set_battery(percent) -> void:
	if percent >= 60.0:
		%BatteryIcon.texture = load("res://assets/icon_full.png")
	elif percent >= 40.0:
		%BatteryIcon.texture = load("res://assets/icon_high.png")
	elif percent >= 20.0:
		%BatteryIcon.texture = load("res://assets/icon_medium.png")
	elif percent >= 1.0:
		%BatteryIcon.texture = load("res://assets/icon_low.png")
	else:
		%BatteryIcon.texture = load("res://assets/icon_empty.png")

func set_signal(percent: float) -> void:
	if percent >= 60.0:
		%SignalIcon.texture = load("res://assets/icon_full.png")
	elif percent >= 40.0:
		%SignalIcon.texture = load("res://assets/icon_high.png")
	elif percent >= 20.0:
		%SignalIcon.texture = load("res://assets/icon_medium.png")
	elif percent >= 1.0:
		%SignalIcon.texture = load("res://assets/icon_low.png")
	else:
		%SignalIcon.texture = load("res://assets/icon_empty.png")
