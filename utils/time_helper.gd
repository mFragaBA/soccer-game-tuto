class_name TimeHelper

static func get_time_text(time_left: float) -> String:
	if time_left < 0:
		return "OVERTIME"
	else:
		var minutes := int(time_left / 60)
		var seconds := int(time_left - minutes * 60)
		return "%02d : %02d" % [minutes, seconds]
