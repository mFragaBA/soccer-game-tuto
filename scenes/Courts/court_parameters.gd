class_name CourtParameters

var friction := 0.25
var bounciness := 0.4
var court_color : Color = Color.GREEN

func set_friction(new_friction : float) -> CourtParameters:
	friction = new_friction
	return self
	
func set_bounciness(new_bounciness : float) -> CourtParameters:
	bounciness = new_bounciness
	return self
